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

func degreesToRadians(_ degrees: Double) -> CGFloat {
  return CGFloat(degrees * Double.pi / 180.0)
}

func radiansToDegrees(_ radians: Double) -> CGFloat {
  return CGFloat(radians / Double.pi * 180.0)
}

class CATransformLayerViewController: UIViewController {
  @IBOutlet weak var boxTappedLabel: UILabel!
  @IBOutlet weak var viewForTransformLayer: UIView!
  @IBOutlet var colorAlphaSwitches: [UISwitch]!

  enum Color: Int {
    case red, orange, yellow, green, blue, purple
  }
  let sideLength = CGFloat(160.0)
  let reducedAlpha = CGFloat(0.8)

  // swiftlint:disable:next implicitly_unwrapped_optional
  var transformLayer: CATransformLayer!
  let swipeMeTextLayer = CATextLayer()
  var redColor = UIColor.red
  var orangeColor = UIColor.orange
  var yellowColor = UIColor.yellow
  var greenColor = UIColor.green
  var blueColor = UIColor.blue
  var purpleColor = UIColor.purple
  var trackBall: TrackBall?

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpSwipeMeTextLayer()
    buildCube()
    sortOutletCollections()
  }
}

// MARK: - Layer setup
extension CATransformLayerViewController {
  func buildCube() {
    transformLayer = CATransformLayer()

    // 添加一个 CALayer 表示立方体的红色面并将其添加到 transformLayer
    let redLayer = sideLayer(color: redColor)
    redLayer.addSublayer(swipeMeTextLayer)
    transformLayer.addSublayer(redLayer)

    let orangeLayer = sideLayer(color: orangeColor)
    var orangeTransform = CATransform3DMakeTranslation(sideLength / 2.0, 0.0, sideLength / -2.0)
    orangeTransform = CATransform3DRotate(orangeTransform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
    orangeLayer.transform = orangeTransform
    transformLayer.addSublayer(orangeLayer)

    let yellowLayer = sideLayer(color: yellowColor)
    yellowLayer.transform = CATransform3DMakeTranslation(0.0, 0.0, -sideLength)
    transformLayer.addSublayer(yellowLayer)

    let greenLayer = sideLayer(color: greenColor)
    var greenTransform = CATransform3DMakeTranslation(sideLength / -2.0, 0.0, sideLength / -2.0)
    greenTransform = CATransform3DRotate(greenTransform, degreesToRadians(90.0), 0.0, 1.0, 0.0)
    greenLayer.transform = greenTransform
    transformLayer.addSublayer(greenLayer)

    let blueLayer = sideLayer(color: blueColor)
    var blueTransform = CATransform3DMakeTranslation(0.0, sideLength / -2.0, sideLength / -2.0)
    blueTransform = CATransform3DRotate(blueTransform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
    blueLayer.transform = blueTransform
    transformLayer.addSublayer(blueLayer)

    let purpleLayer = sideLayer(color: purpleColor)
    var purpleTransform = CATransform3DMakeTranslation(0.0, sideLength / 2.0, sideLength / -2.0)
    purpleTransform = CATransform3DRotate(purpleTransform, degreesToRadians(90.0), 1.0, 0.0, 0.0)
    purpleLayer.transform = purpleTransform
    transformLayer.addSublayer(purpleLayer)

    // 指定 Z 轴上的锚点，几何操作将围绕该锚点进行
    transformLayer.anchorPointZ = sideLength / -2.0
    viewForTransformLayer.layer.addSublayer(transformLayer)
  }

  func setUpSwipeMeTextLayer() {
    swipeMeTextLayer.frame = CGRect(x: 0.0, y: sideLength / 4.0, width: sideLength, height: sideLength / 2.0)
    swipeMeTextLayer.string = "Swipe Me"
    swipeMeTextLayer.alignmentMode = CATextLayerAlignmentMode.center
    swipeMeTextLayer.foregroundColor = UIColor.white.cgColor
    let fontName = "Noteworthy-Light" as CFString
    let fontRef = CTFontCreateWithName(fontName, 24.0, nil)
    swipeMeTextLayer.font = fontRef
    swipeMeTextLayer.contentsScale = UIScreen.main.scale
  }
}

// MARK: - IBActions
extension CATransformLayerViewController {
  @IBAction func colorAlphaSwitchChanged(_ sender: UISwitch) {
    let alpha = sender.isOn ? reducedAlpha : 1.0

    switch (colorAlphaSwitches as NSArray).index(of: sender) {
    case Color.red.rawValue:
      redColor = colorForColor(redColor, withAlpha: alpha)
    case Color.orange.rawValue:
      orangeColor = colorForColor(orangeColor, withAlpha: alpha)
    case Color.yellow.rawValue:
      yellowColor = colorForColor(yellowColor, withAlpha: alpha)
    case Color.green.rawValue:
      greenColor = colorForColor(greenColor, withAlpha: alpha)
    case Color.blue.rawValue:
      blueColor = colorForColor(blueColor, withAlpha: alpha)
    case Color.purple.rawValue:
      purpleColor = colorForColor(purpleColor, withAlpha: alpha)
    default:
      break
    }

    transformLayer.removeFromSuperlayer()
    buildCube()
  }
}

// MARK: - Touch Handling
extension CATransformLayerViewController {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForTransformLayer) {
      if trackBall != nil {
        trackBall?.setStartPointFromLocation(location)
      } else {
        trackBall = TrackBall(location: location, inRect: viewForTransformLayer.bounds)
      }

      guard let layers = transformLayer.sublayers else {
        return
      }

      for layer in layers {
        if layer.hitTest(location) != nil {
          showBoxTappedLabel()
          break
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForTransformLayer) {
      if let transform = trackBall?.rotationTransformForLocation(location) {
        viewForTransformLayer.layer.sublayerTransform = transform
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForTransformLayer) {
      trackBall?.finalizeTrackBallForLocation(location)
    }
  }

  func showBoxTappedLabel() {
    boxTappedLabel.alpha = 1.0
    boxTappedLabel.isHidden = false

    UIView.animate(
      withDuration: 0.5,
      animations: {
        self.boxTappedLabel.alpha = 0.0
      }, completion: { _ in
        self.boxTappedLabel.isHidden = true
      })
  }
}

// MARK: - Helpers
extension CATransformLayerViewController {
  func sideLayer(color: UIColor) -> CALayer {
    let layer = CALayer()
    layer.frame = CGRect(origin: .zero, size: CGSize(width: sideLength, height: sideLength))
    layer.position = CGPoint(x: viewForTransformLayer.bounds.midX, y: viewForTransformLayer.bounds.midY)
    layer.backgroundColor = color.cgColor
    return layer
  }

  func colorForColor(_ color: UIColor, withAlpha newAlpha: CGFloat) -> UIColor {
    var color = color
    var red = CGFloat()
    var green = red, blue = red, alpha = red

    if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      color = UIColor(red: red, green: green, blue: blue, alpha: newAlpha)
    }

    return color
  }

  func sortOutletCollections() {
    colorAlphaSwitches.sortUIViewsInPlaceByTag()
  }
}
