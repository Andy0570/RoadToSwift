//
//  UIBarButtonItem+Extensions.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 23.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

// Codes are from gist
// https://gist.github.com/yonat/75a0f432d791165b1fd6#gistcomment-2336724

import UIKit

public class BadgeBarButtonItem: UIBarButtonItem {
  
  private(set) lazy var badgeLabel: UILabel = {
    let label = UILabel()
    
    label.text = badgeText?.isEmpty == false ? " \(badgeText!) " : nil
    label.isHidden = badgeText?.isEmpty != false
    label.textColor = badgeFontColor
    label.backgroundColor = badgeBackgroundColor
    
    label.font = .systemFont(ofSize: badgeFontSize)
    label.layer.cornerRadius = badgeFontSize * CGFloat(0.6)
    label.clipsToBounds = true
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.addConstraint(
      NSLayoutConstraint(
        item: label,
        attribute: .width,
        relatedBy: .greaterThanOrEqual,
        toItem: label,
        attribute: .height,
        multiplier: 1,
        constant: 0
      )
    )
    
    return label
  }()
  
  var badgeButton: UIButton? {
    return customView as? UIButton
  }
  
  var badgeText: String? {
    didSet {
      badgeLabel.text = badgeText?.isEmpty == false ? " \(badgeText!) " : nil
      badgeLabel.isHidden = badgeText?.isEmpty != false
      badgeLabel.sizeToFit()
    }
  }
  
  var badgeBackgroundColor: UIColor = .red {
    didSet { badgeLabel.backgroundColor = badgeBackgroundColor }
  }
  
  var badgeFontColor: UIColor = .white {
    didSet { badgeLabel.textColor = badgeFontColor }
  }
  
  var badgeFontSize: CGFloat = UIFont.smallSystemFontSize {
    didSet {
      badgeLabel.font = .systemFont(ofSize: badgeFontSize)
      badgeLabel.layer.cornerRadius = badgeFontSize * CGFloat(0.6)
      badgeLabel.sizeToFit()
    }
  }
}

public extension BadgeBarButtonItem {
  
  convenience init(button: UIButton, badgeText: String? = nil, target: AnyObject?, action: Selector) {
    self.init(customView: button)
    
    self.badgeText = badgeText
    
    button.addTarget(target, action: action, for: .touchUpInside)
    button.sizeToFit()
    button.addSubview(badgeLabel)
    
    button.addConstraint(
      NSLayoutConstraint(
        item: badgeLabel,
        attribute: button.currentTitle?.isEmpty == false ? .top : .centerY,
        relatedBy: .equal,
        toItem: button,
        attribute: .top,
        multiplier: 1,
        constant: 0
      )
    )
    
    button.addConstraint(
      NSLayoutConstraint(
        item: badgeLabel,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: button,
        attribute: .trailing,
        multiplier: 1,
        constant: 0
      )
    )
  }
}

public extension BadgeBarButtonItem {
  
  convenience init(image: UIImage, badgeText: String? = nil, target: AnyObject?, action: Selector) {
    let button = UIButton(type: .custom)
    button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    button.setBackgroundImage(image, for: .normal)
    
    self.init(button: button, badgeText: badgeText, target: target, action: action)
  }
  
  convenience init(title: String, badgeText: String? = nil, target: AnyObject?, action: Selector) {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
    
    self.init(button: button, badgeText: badgeText, target: target, action: action)
  }
  
  convenience init?(image: String, badgeText: String? = nil, target: AnyObject?, action: Selector) {
    guard let image = UIImage(named: image) else { return nil }
    self.init(image: image, badgeText: badgeText, target: target, action: action)
  }
}
