/// Copyright (c) 2020 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CAReplicatorLayerViewController: UIViewController {
  @IBOutlet weak var viewForReplicatorLayer: UIView!
  @IBOutlet weak var layerSizeSlider: UISlider!
  @IBOutlet weak var layerSizeSliderValueLabel: UILabel!
  @IBOutlet weak var instanceCountSlider: UISlider!
  @IBOutlet weak var instanceCountSliderValueLabel: UILabel!
  @IBOutlet weak var instanceDelaySlider: UISlider!
  @IBOutlet weak var instanceDelaySliderValueLabel: UILabel!
  @IBOutlet weak var offsetRedSwitch: UISwitch!
  @IBOutlet weak var offsetGreenSwitch: UISwitch!
  @IBOutlet weak var offsetBlueSwitch: UISwitch!
  @IBOutlet weak var offsetAlphaSwitch: UISwitch!

  let lengthMultiplier: CGFloat = 3.0
  let replicatorLayer = CAReplicatorLayer()
  let instanceLayer = CALayer()
  let fadeAnimation = CABasicAnimation(keyPath: "opacity")

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpReplicatorLayer()
    setUpInstanceLayer()
    setUpLayerFadeAnimation()
    instanceDelaySliderChanged(instanceDelaySlider)
    updateLayerSizeSliderValueLabel()
    updateInstanceCountSliderValueLabel()
    updateInstanceDelaySliderValueLabel()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setUpReplicatorLayer()
    setUpInstanceLayer()
  }
}

// MARK: - Layer setup
extension CAReplicatorLayerViewController {
  // 使用 CAReplicatorLayer 创建加载动画
  // CAReplicatorLayer 可以将 layer 复制指定次数，以实现一些炫酷的效果
  func setUpReplicatorLayer() {
    replicatorLayer.frame = viewForReplicatorLayer.bounds

    // 复制数量、创建实例之间的延迟
    let count = instanceCountSlider.value
    replicatorLayer.instanceCount = Int(count)
    replicatorLayer.instanceDelay = CFTimeInterval(instanceDelaySlider.value / count)

    // 设置各个实例的色彩偏移量
    replicatorLayer.instanceColor = UIColor.white.cgColor
    replicatorLayer.instanceRedOffset = offsetValueForSwitch(offsetRedSwitch)
    replicatorLayer.instanceGreenOffset = offsetValueForSwitch(offsetGreenSwitch)
    replicatorLayer.instanceBlueOffset = offsetValueForSwitch(offsetBlueSwitch)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)

    // 旋转每个实例以创建圆形效果
    let angle = Float.pi * 2.0 / count
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)

    viewForReplicatorLayer.layer.addSublayer(replicatorLayer)
  }

  // 为 CAReplicatorLayer 添加一个实例层
  func setUpInstanceLayer() {
    let layerWidth = CGFloat(layerSizeSlider.value)
    let midX = viewForReplicatorLayer.bounds.midX - layerWidth / 2.0
    instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * lengthMultiplier)
    instanceLayer.backgroundColor = UIColor.white.cgColor
    replicatorLayer.addSublayer(instanceLayer)
  }

  func setUpLayerFadeAnimation() {
    // 使用 CABasicAnimation 将实例的不透明度从 1（不透明）更改为 0（透明）
    fadeAnimation.fromValue = 1.0
    fadeAnimation.toValue = 0.0
    fadeAnimation.repeatCount = Float(Int.max)
  }
}

// MARK: - IBActions
extension CAReplicatorLayerViewController {
  @IBAction func layerSizeSliderChanged(_ sender: UISlider) {
    let value = CGFloat(sender.value)
    instanceLayer.bounds = CGRect(origin: .zero, size: CGSize(width: value, height: value * lengthMultiplier))
    updateLayerSizeSliderValueLabel()
  }

  @IBAction func instanceCountSliderChanged(_ sender: UISlider) {
    replicatorLayer.instanceCount = Int(sender.value)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
    updateInstanceCountSliderValueLabel()
  }

  @IBAction func instanceDelaySliderChanged(_ sender: UISlider) {
    if sender.value > 0.0 {
      replicatorLayer.instanceDelay = CFTimeInterval(sender.value / Float(replicatorLayer.instanceCount))
      setLayerFadeAnimation()
    } else {
      replicatorLayer.instanceDelay = 0.0
      instanceLayer.opacity = 1.0
      instanceLayer.removeAllAnimations()
    }

    updateInstanceDelaySliderValueLabel()
  }

  @IBAction func offsetSwitchChanged(_ sender: UISwitch) {
    switch sender {
    case offsetRedSwitch:
      replicatorLayer.instanceRedOffset = offsetValueForSwitch(sender)
    case offsetGreenSwitch:
      replicatorLayer.instanceGreenOffset = offsetValueForSwitch(sender)
    case offsetBlueSwitch:
      replicatorLayer.instanceBlueOffset = offsetValueForSwitch(sender)
    case offsetAlphaSwitch:
      replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(sender)
    default:
      break
    }
  }
}

// MARK: - Triggered actions
extension CAReplicatorLayerViewController {
  func setLayerFadeAnimation() {
    instanceLayer.opacity = 0.0
    fadeAnimation.duration = CFTimeInterval(instanceDelaySlider.value)
    instanceLayer.add(fadeAnimation, forKey: "FadeAnimation")
  }
}

// MARK: - Helpers
extension CAReplicatorLayerViewController {
  func offsetValueForSwitch(_ offsetSwitch: UISwitch) -> Float {
    if offsetSwitch == offsetAlphaSwitch {
      let count = Float(replicatorLayer.instanceCount)
      return offsetSwitch.isOn ? -1.0 / count : 0.0
    } else {
      return offsetSwitch.isOn ? 0.0 : -0.05
    }
  }

  func updateLayerSizeSliderValueLabel() {
    let value = layerSizeSlider.value
    layerSizeSliderValueLabel.text = String(format: "%.0f x %.0f", value, value * Float(lengthMultiplier))
  }

  func updateInstanceCountSliderValueLabel() {
    instanceCountSliderValueLabel.text = String(format: "%.0f", instanceCountSlider.value)
  }

  func updateInstanceDelaySliderValueLabel() {
    instanceDelaySliderValueLabel.text = String(format: "%.0f", instanceDelaySlider.value)
  }
}
