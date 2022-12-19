/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

extension UIImage {
  private enum ScaleFactor {
    static let retinaToEye: CGFloat = 0.5
    static let faceBoundsToEye: CGFloat = 4.0
  }

  func faceOverlayImageFrom() -> UIImage? {
    guard
      let detector = CIDetector(
        ofType: CIDetectorTypeFace,
        context: nil,
        options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
      )
    else {
      return nil
    }

    // Get features from the image
    guard let cgImage = cgImage else {
      return nil
    }
    let newImage = CIImage(cgImage: cgImage)
    guard let features = detector.features(in: newImage) as? [CIFaceFeature] else {
      return nil
    }

    UIGraphicsBeginImageContext(size)
    let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    // Draws this in the upper left coordinate system
    draw(in: imageRect, blendMode: .normal, alpha: 1.0)

    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    for faceFeature in features {
      let faceRect = faceFeature.bounds
      context.saveGState()

      // CI and CG work in different coordinate systems, we should translate to
      // the correct one so we don't get mixed up when calculating the face position.
      context.translateBy(x: 0.0, y: imageRect.size.height)
      context.scaleBy(x: 1.0, y: -1.0)

      if faceFeature.hasLeftEyePosition {
        let leftEyePosition = faceFeature.leftEyePosition
        let eyeWidth = faceRect.size.width / ScaleFactor.faceBoundsToEye
        let eyeHeight = faceRect.size.height / ScaleFactor.faceBoundsToEye
        let eyeRect = CGRect(
          x: leftEyePosition.x - eyeWidth / 2.0,
          y: leftEyePosition.y - eyeHeight / 2.0,
          width: eyeWidth,
          height: eyeHeight
        )
        drawEyeBallForFrame(eyeRect)
      }

      if faceFeature.hasRightEyePosition {
        let leftEyePosition = faceFeature.rightEyePosition
        let eyeWidth = faceRect.size.width / ScaleFactor.faceBoundsToEye
        let eyeHeight = faceRect.size.height / ScaleFactor.faceBoundsToEye
        let eyeRect = CGRect(
          x: leftEyePosition.x - eyeWidth / 2.0,
          y: leftEyePosition.y - eyeHeight / 2.0,
          width: eyeWidth,
          height: eyeHeight
        )
        drawEyeBallForFrame(eyeRect)
      }

      context.restoreGState()
    }

    let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return overlayImage
  }

  func faceRotationInRadians(leftEyePoint startPoint: CGPoint, rightEyePoint endPoint: CGPoint) -> CGFloat {
    let deltaX = endPoint.x - startPoint.x
    let deltaY = endPoint.y - startPoint.y
    let angleInRadians = CGFloat(atan2f(Float(deltaY), Float(deltaX)))

    return angleInRadians
  }

  func drawEyeBallForFrame(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.addEllipse(in: rect)
    context?.setFillColor(UIColor.white.cgColor)
    context?.fillPath()

    let eyeSizeWidth = rect.size.width * ScaleFactor.retinaToEye
    let eyeSizeHeight = rect.size.height * ScaleFactor.retinaToEye

    var x = CGFloat.random(in: 0...CGFloat(rect.size.width - eyeSizeWidth))
    var y = CGFloat.random(in: 0...CGFloat(rect.size.height - eyeSizeHeight))
    x += rect.origin.x
    y += rect.origin.y

    let eyeSize = min(eyeSizeWidth, eyeSizeHeight)
    let eyeBallRect = CGRect(x: x, y: y, width: eyeSize, height: eyeSize)
    context?.addEllipse(in: eyeBallRect)
    context?.setFillColor(UIColor.black.cgColor)
    context?.fillPath()
  }
}
