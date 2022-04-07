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

class CAEmitterLayerControlsViewController: UITableViewController {
  @IBOutlet weak var renderModePickerValueLabel: UILabel!
  @IBOutlet weak var renderModePicker: UIPickerView!
  @IBOutlet var sliderValueLabels: [UILabel]!
  @IBOutlet weak var enabledSwitch: UISwitch!
  @IBOutlet var sliders: [UISlider]!

  enum Section: Int {
    case emitterLayer, emitterCell
  }
  enum Slider: Int {
    case
    color,
    redRange,
    greenRange,
    blueRange,
    alphaRange,
    redSpeed,
    greenSpeed,
    blueSpeed,
    alphaSpeed,
    scale,
    scaleRange,
    spin,
    spinRange,
    emissionLatitude,
    emissionLongitude,
    emissionRange,
    lifetime,
    lifetimeRange,
    birthRate,
    velocity,
    velocityRange,
    xAcceleration,
    yAcceleration
  }

  // swiftlint:disable:next implicitly_unwrapped_optional
  weak var emitterLayerViewController: CAEmitterLayerViewController!
  var emitterLayer: CAEmitterLayer {
    return emitterLayerViewController.emitterLayer
  }
  var emitterCell: CAEmitterCell {
    return emitterLayerViewController.emitterCell
  }
  let emitterLayerRenderModes: [CAEmitterLayerRenderMode] = [
    .unordered,
    .oldestFirst,
    .oldestLast,
    .backToFront,
    .additive
  ]
  var renderModePickerVisible = false

  override func viewDidLoad() {
    super.viewDidLoad()
    updateSliderValueLabels()
  }
}

// MARK: - IBActions
extension CAEmitterLayerControlsViewController {
  @IBAction func enabledSwitchChanged(_ sender: UISwitch) {
    emitterLayerViewController.emitterCell.isEnabled = sender.isOn
    emitterLayerViewController.resetEmitterCells()
  }

  // swiftlint:disable:next cyclomatic_complexity
  @IBAction func sliderChanged(_ sender: UISlider) {
    let slidersArray = sliders as NSArray
    // swiftlint:disable:next force_unwrapping
    let slider = Slider(rawValue: slidersArray.index(of: sender))!
    var keyPath = "emitterCell."

    switch slider {
    case .color: keyPath += "color"
    case .redRange: keyPath += "redRange"
    case .greenRange: keyPath += "greenRange"
    case .blueRange: keyPath += "blueRange"
    case .alphaRange: keyPath += "alphaRange"
    case .redSpeed: keyPath += "redSpeed"
    case .greenSpeed: keyPath += "greenSpeed"
    case .blueSpeed: keyPath += "blueSpeed"
    case .alphaSpeed: keyPath += "alphaSpeed"
    case .scale: keyPath  += "scale"
    case .scaleRange: keyPath += "scaleRange"
    case .spin: keyPath += "spin"
    case .spinRange: keyPath += "spinRange"
    case .emissionLatitude: keyPath += "emissionLatitude"
    case .emissionLongitude: keyPath += "emissionLongitude"
    case .emissionRange: keyPath += "emissionRange"
    case .lifetime: keyPath += "lifetime"
    case .lifetimeRange: keyPath += "lifetimeRange"
    case .birthRate: keyPath += "birthRate"
    case .velocity: keyPath += "velocity"
    case .velocityRange: keyPath += "velocityRange"
    case .xAcceleration: keyPath += "xAcceleration"
    case .yAcceleration: keyPath += "yAcceleration"
    }

    if keyPath == "emitterCell.color" {
      let color = UIColor(hue: 0.0, saturation: 0.0, brightness: CGFloat(sender.value), alpha: 1.0)
      emitterLayerViewController.emitterCell.color = color.cgColor
      emitterLayerViewController.resetEmitterCells()
    } else {
      emitterLayerViewController.setValue(NSNumber(value: sender.value as Float), forKeyPath: keyPath)
      emitterLayerViewController.resetEmitterCells()
    }

    updateSliderValueLabel(slider)
  }
}

// MARK: - Triggered actions
extension CAEmitterLayerControlsViewController {
  func showEmitterLayerRenderModePicker() {
    renderModePickerVisible = true
    relayoutTableViewCells()
    let index = emitterLayerRenderModes.firstIndex(of: emitterLayer.renderMode) ?? 0
    renderModePicker.selectRow(index, inComponent: 0, animated: false)
    renderModePicker.isHidden = false
    renderModePicker.alpha = 0.0

    UIView.animate(withDuration: 0.25) {
      self.renderModePicker.alpha = 1.0
    }
  }

  func hideEmitterLayerRenderModePicker() {
    if renderModePickerVisible {
      view.isUserInteractionEnabled = false
      renderModePickerVisible = false
      relayoutTableViewCells()

      UIView.animate(
        withDuration: 0.25,
        animations: {
          self.renderModePicker.alpha = 0.0
        },
        completion: { _ in
          self.renderModePicker.isHidden = true
          self.view.isUserInteractionEnabled = true
        })
    }
  }
}

// MARK: - Helpers
extension CAEmitterLayerControlsViewController {
  func updateSliderValueLabels() {
    for slider in Slider.color.rawValue...Slider.yAcceleration.rawValue {
      // swiftlint:disable:next force_unwrapping
      updateSliderValueLabel(Slider(rawValue: slider)!)
    }
  }

  func updateSliderValueLabel(_ sliderEnum: Slider) {
    let index = sliderEnum.rawValue
    let label = sliderValueLabels[index]
    let slider = sliders[index]

    switch sliderEnum {
    case
    .redRange,
    .greenRange,
    .blueRange,
    .alphaRange,
    .redSpeed,
    .greenSpeed,
    .blueSpeed,
    .alphaSpeed,
    .scale,
    .scaleRange,
    .lifetime,
    .lifetimeRange:
      label.text = String(format: "%.1f", slider.value)
    case .color:
      label.text = String(format: "%.0f", slider.value * 100.0)
    case .spin, .spinRange, .emissionLatitude, .emissionLongitude, .emissionRange:
      let formatter = NumberFormatter()
      formatter.minimumFractionDigits = 0
      label.text = "\(Int(radiansToDegrees(Double(slider.value))))"
    case .birthRate, .velocity, .velocityRange, .xAcceleration, .yAcceleration:
      label.text = String(format: "%.0f", slider.value)
    }
  }

  func relayoutTableViewCells() {
    tableView.beginUpdates()
    tableView.endUpdates()
  }
}

// MARK: - UITableViewDelegate
extension CAEmitterLayerControlsViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // swiftlint:disable:next force_unwrapping
    let section = Section(rawValue: indexPath.section)!

    if section == .emitterLayer && indexPath.row == 1 {
      return renderModePickerVisible ? 162.0 : 0.0
    } else {
      return 44.0
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // swiftlint:disable:next force_unwrapping
    let section = Section(rawValue: indexPath.section)!

    switch section {
    case .emitterLayer where !renderModePickerVisible:
      showEmitterLayerRenderModePicker()
    default:
      hideEmitterLayerRenderModePicker()
    }
  }
}

// MARK: - UIPickerViewDataSource
extension CAEmitterLayerControlsViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return emitterLayerRenderModes.count
  }
}

// MARK: - UIPickerViewDelegate
extension CAEmitterLayerControlsViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return emitterLayerRenderModes[row].rawValue
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    emitterLayerViewController.emitterLayer.renderMode = emitterLayerRenderModes[row]
    renderModePickerValueLabel.text = emitterLayer.renderMode.rawValue
  }
}
