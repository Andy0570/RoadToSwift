原文：[Adding Insets to a UILabel](https://chrishannah.me/adding-insets-to-a-uilabel/)

I ran into a situation at work today, where I was already using a UILabel to display text, but it was styled in a way that really needed some padding.

UILabel doesn’t directly support this, and the most common way to get around it is to embed the UILabel inside a UIView, and control the constraints that way. I didn’t really want to do that for what I was doing, and I also wanted to just make my own label that could handle padding.

It didn’t take long and was a lot more straightforward than I thought. I subclasses UIClass, added a UIEdgeInsets variable, and then made sure that intrinsicContentSize, sizeThatFits(_ size: CGSize), and drawText(in rect: CGRect) took that into consideration. So it still works perfectly with AutoLayout.

```swift
import UIKit

class InsetLabel: UILabel {

	var contentInsets = UIEdgeInsets.zero

	override func drawText(in rect: CGRect) {
		let insetRect = UIEdgeInsetsInsetRect(rect, contentInsets)
		super.drawText(in: insetRect)
	}

	override var intrinsicContentSize: CGSize {
		return addInsets(to: super.intrinsicContentSize)
	}

	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return addInsets(to: super.sizeThatFits(size))
	}

	private func addInsets(to size: CGSize) -> CGSize {
		let width = size.width + contentInsets.left + contentInsets.right
		let height = size.height + contentInsets.top + contentInsets.bottom
		return CGSize(width: width, height: height)
	}

}
```

It’s certainly not a major open source project or anything, but it could be a quick way to add padding support to a UILabel!