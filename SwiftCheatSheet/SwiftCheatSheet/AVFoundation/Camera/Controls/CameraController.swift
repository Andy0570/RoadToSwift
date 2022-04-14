//
//  CameraController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/29.
//

/**
 iOS 上的相机捕捉

 参考：<https://objccn.io/issue-21-3/>
 */
import UIKit
import AVFoundation

/// Observer key
enum Constants {
    static let CameraControllerDidStartSession = "CameraControllerDidStartSession"
    static let CameraControllerDidStopSession = "CameraControllerDidStopSession"

    static let CameraControlObservableSettingLensPosition = "CameraControlObservableSettingLensPosition"
    static let CameraControlObservableSettingExposureTargetOffset = "CameraControlObservableSettingExposureTargetOffset"
    static let CameraControlObservableSettingExposureDuration = "CameraControlObservableSettingExposureDuration"
    static let CameraControlObservableSettingISO = "CameraControlObservableSettingISO"
    static let CameraControlObservableSettingWBGains = "CameraControlObservableSettingWBGains"
    static let CameraControlObservableSettingAdjustingFocus = "CameraControlObservableSettingAdjustingFocus"
    static let CameraControlObservableSettingAdjustingExposure = "CameraControlObservableSettingAdjustingExposure"
    static let CameraControlObservableSettingAdjustingWhiteBalance = "CameraControlObservableSettingAdjustingWhiteBalance"
}

enum CameraControllerPreviewType {
    case previewLayer
    case manual
}

protocol CameraControllerDelegate: AnyObject {
    func cameraController(_ cameraController: CameraController, didDetectFaces faces: [(id: Int, frame: CGRect)])
}

protocol CameraFramesDelegate: AnyObject {
    func cameraController(_ cameraController: CameraController, didOutputImage image: CIImage)
}

@objc protocol CameraSettingValueObserver {
    func cameraSetting(setting: String, valueChanged value: AnyObject)
}

extension AVCaptureDevice.WhiteBalanceGains {
    // 设置相机的白平衡 RGB 增益值
    mutating func clampGainsToRange(minValue: Float, maxValue: Float) {
        blueGain = max(min(blueGain, maxValue), minValue)
        redGain = max(min(redGain, maxValue), minValue)
        greenGain = max(min(greenGain, maxValue), minValue)
    }
}

// 将设备特定的 RGB 白平衡增益值转换为设备无关的温度和色调。
class WhiteBalanceValues {
    var temperature: Float
    var tint: Float

    init(temperature: Float, tint: Float) {
        self.temperature = temperature
        self.tint = tint
    }

    convenience init(temperatureAndTintValues: AVCaptureDevice.WhiteBalanceTemperatureAndTintValues) {
        self.init(temperature: temperatureAndTintValues.temperature, tint: temperatureAndTintValues.tint)
    }
}

class CameraController: NSObject {
    weak var delegate: CameraControllerDelegate?
    weak var frameDelegate: CameraFramesDelegate?

    var previewType: CameraControllerPreviewType

    var previewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            previewLayer?.session = session
        }
    }

    // 是否开启分级捕捉
    var enableBracketedCapture = false {
        didSet {
            // TODO: if true, prepere for capture
        }
    }

    // MARK: Private properties

    private var currentCameraDevice: AVCaptureDevice?

    // 自定义串行队列，确保视频帧按顺序到达
    private var sessionQueue = DispatchQueue(label: "com.example.session_access_queue")
    private var session: AVCaptureSession!
    private var backCameraDevice: AVCaptureDevice?
    private var frontCameraDevice: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput!
    private var videoOutput: AVCaptureVideoDataOutput!
    private var metadataOutput: AVCaptureMetadataOutput!

    private var lensPositionContext = 0
    private var adjustingFocusContext = 0
    private var adjustingExposureContext = 0
    private var adjustingWhiteBalanceContext = 0
    private var exposureDuration = 0
    private var ISO = 0 // 感光度
    private var exposureTargetOffsetContext = 0
    private var deviceWhiteBalanceGainsContext = 0

    private var controlObservers: [String: [AnyObject]] = [:]

    // MARK: - Initialization

    init(previewType: CameraControllerPreviewType, delegate: CameraControllerDelegate) {
        self.previewType = previewType
        self.delegate = delegate
        super.init()

        initializeSession()
    }

    convenience init(delegate: CameraControllerDelegate) {
        self.init(previewType: .previewLayer, delegate: delegate)
    }

    func initializeSession() {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo // 为照片捕捉设置最合适的配置

        // 向用户获取相机访问权限
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    self.configureSession()
                } else {
                    self.showAccessDeniedMessage()
                }
            }
        case .authorized:
            configureSession()
        case .restricted, .denied:
            showAccessDeniedMessage()
        @unknown default:
            fatalError("Unknown Error.")
        }
    }

    // MARK: - Camera Control

    func startRunning() {
        performConfiguration {
            self.observeValues()
            self.session.startRunning()
            NotificationCenter.default.post(name: NSNotification.Name(Constants.CameraControllerDidStartSession), object: self)
        }
    }

    func stopRunning() {
        performConfiguration {
            self.unobserveValues()
            self.session.stopRunning()
        }
    }

    // 注册观察者，将观察者缓存到 controlObservers
    func registerObserver<T>(observer: T, property: String) where T: NSObject, T: CameraSettingValueObserver {
        var propertyObservers: [AnyObject] = []
        if let existedObserver = controlObservers[property] {
            propertyObservers = existedObserver
        }

        propertyObservers.append(observer)
        controlObservers[property] = propertyObservers
    }

    // 移除观察者，更新 controlObservers 缓存列表
    func unregisterObserver<T>(observer: T, property: String) where T: NSObject, T: CameraSettingValueObserver {
        if let propertyObservers = controlObservers[property] {
            let filteredPropertyObservers = propertyObservers.filter { $0 as! NSObject != observer }
            controlObservers[property] = filteredPropertyObservers
        }
    }

    // MARK: Focus 对焦

    // 在 iOS 相机中，对焦是通过移动镜片改变其到传感器之间的距离实现的。
    // 自动对焦是通过相位检测和反差检测实现的。然而，反差检测只适用于低分辨率和高 FPS 视频捕捉 (慢镜头)。
    func enableContinuousAutoFocus() {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            if currentDevice.isFocusModeSupported(.continuousAutoFocus) {
                // 当场景改变时，相机会自动重新对焦到画面的中心点。
                currentDevice.focusMode = .continuousAutoFocus
            }
        }
    }

    func isContinuousAutoFocusEnabled() -> Bool {
        return currentCameraDevice?.focusMode == .continuousAutoFocus
    }

    // 手动设置并锁定对焦
    // 通常情况下，AutoFocus 模式会尝试让屏幕中心成为最清晰的点，我们可以通过设置兴趣点来设定另一个区域。
    // 屏幕左上角(0, 0)，屏幕右下角(1 ,1)，屏幕中心点(0.5, 0.5)
    func lockFocusAtPointOfInterest(pointInView: CGPoint) {
        var pointInCamera: CGPoint
        if let previewLayer = previewLayer {
            pointInCamera = previewLayer.captureDevicePointConverted(fromLayerPoint: pointInView)
        } else {
            // TODO: calculate the point without the preview layer
            pointInCamera = pointInView
        }

        performConfigurationOnCurrentCameraDevice { currentDevice in
            if currentDevice.isFocusPointOfInterestSupported {
                // 设置感兴趣的对焦点
                currentDevice.focusPointOfInterest = pointInCamera
                // 指示设备自动对焦一次，然后将对焦模式更改为 AVCaptureFocusModeLocked。
                currentDevice.focusMode = .autoFocus
            }
        }
    }

    // 设置并锁定对焦的镜片位置
    func lockFocusAtLensPosition(lensPosition: CGFloat) {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            // 将 focusMode 设置为 AVCaptureFocusModeLocked 并将 lensPosition 锁定在显式值。
            currentDevice.setFocusModeLocked(lensPosition: Float(lensPosition))
        }
    }

    // 获取并返回当前对焦位置，可能的位置范围是0.0到1.0，其中0.0是镜头可以对焦的最短距离，1.0是最远的距离。
    func currentLensPosition() -> Float? {
        return self.currentCameraDevice?.lensPosition
    }

    // MARK: Exposure 曝光量

    func enableContinuousAutoExposure() {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            if currentDevice.isExposureModeSupported(.continuousAutoExposure) {
                currentDevice.exposureMode = .continuousAutoExposure
            }
        }
    }

    func isContinuousAutoExposureEnabled() -> Bool {
        return currentCameraDevice?.exposureMode == .continuousAutoExposure
    }

    func lockExposureAtPointOfInterest(pointInView: CGPoint) {
        var pointInCamera: CGPoint
        if let previewLayer = previewLayer {
            pointInCamera = previewLayer.captureDevicePointConverted(fromLayerPoint: pointInView)
        } else {
            // TODO: calculate the point without the preview layer
            pointInCamera = pointInView
        }

        performConfigurationOnCurrentCameraDevice { currentDevice in
            if currentDevice.isExposurePointOfInterestSupported {
                currentDevice.exposurePointOfInterest = pointInCamera
                currentDevice.exposureMode = .autoExpose
            }
        }
    }

    // 设置相机的曝光感光度
    func setCustomExposureWithISO(iso: Float) {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            currentDevice.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: iso)
        }
    }

    // 设置自定义曝光时间
    func setCustomExposureWithDuration(duration: Float) {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            let activeFormat = currentDevice.activeFormat
            let finalDuration = CMTimeMakeWithSeconds(Float64(duration), preferredTimescale: 1_000_000)
            let durationRange = CMTimeRangeFromTimeToTime(start: activeFormat.minExposureDuration, end: activeFormat.maxExposureDuration)

            if CMTimeRangeContainsTime(durationRange, time: finalDuration) {
                currentDevice.setExposureModeCustom(duration: finalDuration, iso: AVCaptureDevice.currentISO)
            }
        }
    }

    // 设置曝光档位的目标偏移（曝光补偿）
    func setExposureTargetBias(bias: Float) {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            currentDevice.setExposureTargetBias(bias)
        }
    }

    // 读取并返回当前曝光时间
    func currentExposureDuration() -> Float? {
        guard let exposureDuration = currentCameraDevice?.exposureDuration else {
            return nil
        }

        return Float(CMTimeGetSeconds(exposureDuration))
    }

    // 读取并返回当前曝光感光度
    func currentISO() -> Float? {
        return currentCameraDevice?.iso
    }

    // 读取并返回当前曝光偏移量
    func currentExposureTargetOffset() -> Float? {
        return currentCameraDevice?.exposureTargetOffset
    }

    // MARK: White balance 白平衡

    // 在冷光线的条件下，传感器应该增强红色部分，而在暖光线下增强蓝色部分。
    func enableContinuousAutoWhiteBalance() {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            if currentDevice.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                currentDevice.whiteBalanceMode = .continuousAutoWhiteBalance
            }
        }
    }

    func isContinuousAutoWhiteBalanceEnabled() -> Bool {
        return currentCameraDevice?.whiteBalanceMode == .continuousAutoWhiteBalance
    }

    // 设置白平衡的（开尔文）色温，（2000-3000k 蜡烛暖光源 ～ 8000k 蓝色天空）
    func setCustomWhiteBalanceWithTemperature(temperature: Float) {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            if currentDevice.isWhiteBalanceModeSupported(.locked) {
                // 指示当前设备特定的 RGB 白平衡增益值。
                let currentGains = currentDevice.deviceWhiteBalanceGains
                // 将设备特定的 RGB 白平衡增益值转换为设备无关的温度和色调。
                let currentTint = currentDevice.temperatureAndTintValues(for: currentGains).tint
                let temperatureAndTintValues = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: temperature, tint: currentTint)

                // 将设备无关的色度值转换为设备特定的 RGB 增益值。
                var deviceGains = currentDevice.deviceWhiteBalanceGains(for: temperatureAndTintValues)
                let maxWhiteBalanceGain = currentDevice.maxWhiteBalanceGain
                deviceGains.clampGainsToRange(minValue: 1, maxValue: maxWhiteBalanceGain)

                currentDevice.setWhiteBalanceModeLocked(with: deviceGains)
            }
        }
    }

    // 设置白平衡色调，（-150 偏绿 ～ 150 偏品红）
    func setCustomWhiteBalanceWithTint(tint: Float) {
        performConfigurationOnCurrentCameraDevice { currentDevice in
            if currentDevice.isWhiteBalanceModeSupported(.locked) {
                let maxWhiteBalanceGain = currentDevice.maxWhiteBalanceGain
                var currentGains = currentDevice.deviceWhiteBalanceGains
                currentGains.clampGainsToRange(minValue: 1, maxValue: maxWhiteBalanceGain)
                let currentTemperature = currentDevice.temperatureAndTintValues(for: currentGains).temperature
                let temperatureAndTintValues = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: currentTemperature, tint: tint)

                // 将设备无关的色度值转换为设备特定的 RGB 增益值。
                var deviceGains = currentDevice.deviceWhiteBalanceGains(for: temperatureAndTintValues)
                deviceGains.clampGainsToRange(minValue: 1, maxValue: maxWhiteBalanceGain)

                currentDevice.setWhiteBalanceModeLocked(with: deviceGains)
            }
        }
    }

    // 读取并返回当前白平衡色温
    func currentTemperature() -> Float? {
        guard let gains = currentCameraDevice?.deviceWhiteBalanceGains else {
            return nil
        }
        let tempAndTint = currentCameraDevice?.temperatureAndTintValues(for: gains)
        return tempAndTint?.temperature
    }

    // 读取并返回当前白平衡色调
    func currentTint() -> Float? {
        guard let gains = currentCameraDevice?.deviceWhiteBalanceGains else {
            return nil
        }
        let tempAndTint = currentCameraDevice?.temperatureAndTintValues(for: gains)
        return tempAndTint?.tint
    }

    // MARK: Still image capture 静态图像捕捉

    func captureStillImage(completionHandler handler: @escaping ((_ image: UIImage, _ metadata: NSDictionary) -> Void)) {
        if enableBracketedCapture {
            bracketedCaptureStillImage()
        } else {
            captureSingleStillImage()
        }
    }

    func captureSingleStillImage() {
        sessionQueue.async {
            // 1. 在捕捉会话启动前创建并设置 AVCapturePhotoOutput 对象
            // 2. 创建并配置 AVCapturePhotoSettings 对象以选择特定拍摄的功能和设置（例如，是否启用图像稳定或闪光灯）
            // 注：重复使用 AVCapturePhotoSettings 实例进行多次捕获是非法的。当 settings 对象的 uniqueID 与之前捕获设置对象重复时会导致应用崩溃。
            // <https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/capturing_still_and_live_photos>
            let photoSettings: AVCapturePhotoSettings
            if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            } else {
                photoSettings = AVCapturePhotoSettings()
            }

            // 设置预览缩略图分辨率格式
            if let previewPixelType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                let previewFormat = [
                    kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                    kCVPixelBufferWidthKey as String: 160,
                    kCVPixelBufferHeightKey as String: 160
                ]
                photoSettings.previewPhotoFormat = previewFormat
            }

            // 权衡照片质量应该如何优先于速度
            photoSettings.photoQualityPrioritization = .balanced
            photoSettings.flashMode = .auto

            // 3. 调用 capturePhotoWithSettings:delegate: 方法进行操作
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }

    // 分级捕捉可以在不同的曝光设置下拍摄几张照片，然后用 HDR 算法合成一张
    func bracketedCaptureStillImage() {
        sessionQueue.async {
            // Get AVCaptureBracketedStillImageSettings for a set of exposure values.
            let exposureValues: [Float] = [-2, 0, 2]
            let makeAutoExposureSettings = AVCaptureAutoExposureBracketedStillImageSettings.autoExposureSettings(exposureTargetBias:)
            let exposureSettings = exposureValues.map(makeAutoExposureSettings)

            // Create photo settings for HEIF/HEVC capture and no RAW output
            // and enable cross-bracket image stabilization.
            let photoSettings = AVCapturePhotoBracketSettings(rawPixelFormatType: 0, processedFormat: [AVVideoCodecKey: AVVideoCodecType.hevc], bracketedSettings: exposureSettings)
            photoSettings.isLensStabilizationEnabled = self.photoOutput.isLensStabilizationDuringBracketedCaptureSupported

            // Shoot the bracket, handle capture delegate callbacks.
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }

    // MARK: - Notifications

    func subjectAreaDidChange(notification: NSNotification) {
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        var key = ""
        var newValue: AnyObject = change![NSKeyValueChangeKey.newKey]! as AnyObject

        switch context! {
        case &lensPositionContext:
            key = Constants.CameraControlObservableSettingLensPosition
        case &exposureDuration:
            key = Constants.CameraControlObservableSettingExposureDuration
        case &ISO:
            key = Constants.CameraControlObservableSettingISO
        case &deviceWhiteBalanceGainsContext:
            key = Constants.CameraControlObservableSettingWBGains
            if let newNSValue = newValue as? NSValue {
                var gains: AVCaptureDevice.WhiteBalanceGains?
                newNSValue.getValue(&gains)
                if let newGains = gains,
                    let newTemperatureAndTint = currentCameraDevice?.temperatureAndTintValues(for: newGains) {
                    newValue = WhiteBalanceValues(temperatureAndTintValues: newTemperatureAndTint)
                }
            }
        case &adjustingFocusContext:
            key = Constants.CameraControlObservableSettingAdjustingFocus
        case &adjustingExposureContext:
            key = Constants.CameraControlObservableSettingAdjustingExposure
        case &adjustingWhiteBalanceContext:
            key = Constants.CameraControlObservableSettingAdjustingWhiteBalance
        default:
            key = "unknown context"
        }

        notifyObservers(key: key, value: newValue)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData) else {
            log.error(error?.localizedDescription ?? "获取照片失败")
            return
        }

        // TODO: 通过 Delegate 传递照片
        log.verbose(image)
        log.debug("当前照片数：\(photo.photoCount), 预期的照片数：\(photo.resolvedSettings.expectedPhotoCount)")
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let framesDelegate = frameDelegate, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        // 将图片传给遵守 CameraFramesDelegate 协议的对象
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        framesDelegate.cameraController(self, didOutputImage: image)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension CameraController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let delegate = delegate, let previewLayer = previewLayer else {
            return
        }

        var faces: [(id: Int, frame: CGRect)] = []
        for metadataObject in metadataObjects where metadataObject.type == .face {
            if let faceObject = metadataObject as? AVMetadataFaceObject {
                // TODO: transform object without preview layer?
                if let transformedMetadataObject = previewLayer.transformedMetadataObject(for: metadataObject) {
                    let face = (faceObject.faceID, transformedMetadataObject.bounds)
                    faces.append(face)
                }
            }
        }

        // 将包含人脸的照片传给遵守 CameraControllerDelegate 协议的对象
        DispatchQueue.main.async {
            delegate.cameraController(self, didDetectFaces: faces)
        }
    }
}

// MARK: - Private

private extension CameraController {
    func performConfiguration(block: @escaping (() -> Void)) {
        sessionQueue.async {
            block()
        }
    }

    func performConfigurationOnCurrentCameraDevice(block: @escaping ((_ currentDevice: AVCaptureDevice) -> Void)) {
        if let currentDevice = self.currentCameraDevice {
            performConfiguration {
                do {
                    // 相机设备在改变某些参数前必须先锁定，直到改变结束才能解锁
                    try currentDevice.lockForConfiguration()
                    block(currentDevice)
                    currentDevice.unlockForConfiguration()
                } catch let error {
                    log.error(error.localizedDescription)
                }
            }
        }
    }

    func configureSession() {
        configureDeviceInput()
        configurePhotoOutput()
        configureFaceDetection()
        configureVideoOutput()
    }

    // 设置 session 的输入数据源
    func configureDeviceInput() {
        performConfiguration {
            // <https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/choosing_a_capture_device>
            // 获取用于拍摄视频的前置摄像头
            self.frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
            // 获取用于拍摄视频的后置摄像头
            if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
                self.backCameraDevice = device
            } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                self.backCameraDevice = device
            }

            // 让我们把后置摄像头设置为初始设备
            self.currentCameraDevice = self.backCameraDevice

            // 获取相机设备相关的 AVCaptureDeviceInput 对象，作为 session 的输入
            let possibleCameraInput: AnyObject? = try? AVCaptureDeviceInput(device: self.currentCameraDevice!)
            if let backCameraInput = possibleCameraInput as? AVCaptureDeviceInput {
                if self.session.canAddInput(backCameraInput) {
                    self.session.addInput(backCameraInput)
                }
            }
        }
    }

    // 设置 session 的输出数据源：获取静态图片
    // 注：你不能同时设置获取 Live Photo（实况照片）和视频
    func configurePhotoOutput() {
        performConfiguration {
            // https://developer.apple.com/documentation/avfoundation/avcapturephotooutput
            // AVCapturePhotoOutput 支持 JPEG、实况照片、RAW 格式拍摄、支持双摄、人像模式...
            self.photoOutput = AVCapturePhotoOutput()

            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
            }
        }
    }

    // 设置 session 的输出数据源：获取视频
    func configureVideoOutput() {
        performConfiguration {
            // AVCaptureVideoDataOutput 为实时预览提供原始帧
            self.videoOutput = AVCaptureVideoDataOutput()
            self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate"))

            if self.session.canAddOutput(self.videoOutput) {
                self.session.addOutput(self.videoOutput)
            }
        }
    }

    func configureFaceDetection() {
        performConfiguration {
            // AVCaptureMetadataOutput 用于启用人脸检测和二维码识别
            self.metadataOutput = AVCaptureMetadataOutput()
            self.metadataOutput.setMetadataObjectsDelegate(self, queue: self.sessionQueue)

            if self.session.canAddOutput(self.metadataOutput) {
                self.session.addOutput(self.metadataOutput)
            }

            if self.metadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.face) {
                self.metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.face]
            }
        }
    }

    func observeValues() {
        currentCameraDevice?.addObserver(self, forKeyPath: "lensPosition", options: .new, context: &lensPositionContext)
        currentCameraDevice?.addObserver(self, forKeyPath: "adjustingFocus", options: .new, context: &adjustingFocusContext)
        currentCameraDevice?.addObserver(self, forKeyPath: "adjustingExposure", options: .new, context: &adjustingExposureContext)
        currentCameraDevice?.addObserver(self, forKeyPath: "adjustingWhiteBalance", options: .new, context: &adjustingWhiteBalanceContext)
        currentCameraDevice?.addObserver(self, forKeyPath: "exposureDuration", options: .new, context: &exposureDuration)
        currentCameraDevice?.addObserver(self, forKeyPath: "ISO", options: .new, context: &ISO)
        currentCameraDevice?.addObserver(self, forKeyPath: "deviceWhiteBalanceGains", options: .new, context: &deviceWhiteBalanceGainsContext)
    }

    func unobserveValues() {
        currentCameraDevice?.removeObserver(self, forKeyPath: "lensPosition", context: &lensPositionContext)
        currentCameraDevice?.removeObserver(self, forKeyPath: "adjustingFocus", context: &adjustingFocusContext)
        currentCameraDevice?.removeObserver(self, forKeyPath: "adjustingExposure", context: &adjustingExposureContext)
        currentCameraDevice?.removeObserver(self, forKeyPath: "adjustingWhiteBalance", context: &adjustingWhiteBalanceContext)
        currentCameraDevice?.removeObserver(self, forKeyPath: "exposureDuration", context: &exposureDuration)
        currentCameraDevice?.removeObserver(self, forKeyPath: "ISO", context: &ISO)
        currentCameraDevice?.removeObserver(self, forKeyPath: "deviceWhiteBalanceGains", context: &deviceWhiteBalanceGainsContext)
    }


    // TODO: 当用户拒绝时，引导用户至系统设置页开启
    func showAccessDeniedMessage() {
        log.debug("当用户拒绝时，引导用户至系统设置页开启")
    }

    func notifyObservers(key: String, value: AnyObject) {
        if let lensPositionObservers = controlObservers[key] {
            for obj in lensPositionObservers as [AnyObject] {
                if let observer = obj as? CameraSettingValueObserver {
                    notifyObserver(observer: observer, setting: key, value: value)
                }
            }
        }
    }

    func notifyObserver<T>(observer: T, setting: String, value: AnyObject) where T: CameraSettingValueObserver {
        observer.cameraSetting(setting: setting, valueChanged: value)
    }
}
