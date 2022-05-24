//
//  UIViewController+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import UIKit

extension UIViewController {
    // Get user's documents directory path
    func getDocumentDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = arrayPaths[0]
        return docDirectoryPath
    }

    // Get user's cache directory path
    func getCacheDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectoryPath = arrayPaths[0]
        return cacheDirectoryPath
    }

    // Get user's temp directory path
    func getTempDirectoryPath() -> URL {
        let tempDirectoryPath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        return tempDirectoryPath
    }

    func showToast(message: String, font: UIFont, toastColor: UIColor = UIColor.white, toastBackground: UIColor = UIColor.black) {
        let toastLabel = UILabel()
        toastLabel.textColor = toastColor
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 6
        toastLabel.backgroundColor = toastBackground
        toastLabel.clipsToBounds  =  true

        let toastWidth: CGFloat = toastLabel.intrinsicContentSize.width + 16
        let toastHeight: CGFloat = 32

        toastLabel.frame = CGRect(
            x: self.view.frame.width / 2 - (toastWidth / 2),
            y: self.view.frame.height - (toastHeight * 3),
            width: toastWidth,
            height: toastHeight
        )
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 1.5, delay: 0.25, options: .autoreverse) {
            toastLabel.alpha = 1.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }

    func animateWithKeyboard(notification: NSNotification, animations: ((_ keyboardFrame: CGRect) -> Void)?) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double

        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue

        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            // Perform the necessary animation layout updates
             animations?(keyboardFrameValue.cgRectValue)

            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }

        // Start the animation
        animator.startAnimation()
    }
}
