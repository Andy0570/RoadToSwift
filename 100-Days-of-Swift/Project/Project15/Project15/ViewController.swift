//
//  ViewController.swift
//  Project15
//
//  Created by Qilin Hu on 2021/12/31.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
        view.addSubview(imageView)
    }

    // MARK: - Actions
    
    @IBAction func tapped(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        button.isHidden = true
    
//        UIView.animate(withDuration: 1, delay: 0, options: []) {
//
//            switch self.currentAnimation {
//            case 0:
//                // 将图像放大2倍
//                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
//            case 1:
//                // 重置
//                self.imageView.transform = .identity
//            case 2:
//                // 移动图像
//                self.imageView.transform = CGAffineTransform(translationX: -187, y: -187)
//            case 3:
//                // 重置
//                self.imageView.transform = .identity
//            case 4:
//                // 旋转变换
//                // MARK: Core Animation 将总是采取最短的路线来使旋转工作，所以，如果你的对象是直的，你旋转到90度（弧度：π的一半），
//                // 它将顺时针旋转。如果你的对象是直的，而你旋转到270度（弧度：π+π的一半），它将逆时针旋转，因为这是最小的可能动画。
//                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//            case 5:
//                // 重置
//                self.imageView.transform = .identity
//            case 6:
//                self.imageView.alpha = 0.1
//                self.imageView.backgroundColor = UIColor.green
//            case 7:
//                self.imageView.alpha = 1
//                self.imageView.backgroundColor = UIColor.clear
//            default:
//                break
//            }
//        } completion: { finished in
//            button.isHidden = false
//        }
        
        // MARK: 弹簧动画
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            switch self.currentAnimation {
            case 0:
                // 将图像放大2倍
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                // 重置
                self.imageView.transform = .identity
            case 2:
                // 移动图像
                self.imageView.transform = CGAffineTransform(translationX: -187, y: -187)
            case 3:
                // 重置
                self.imageView.transform = .identity
            case 4:
                // 旋转变换
                // MARK: Core Animation 将总是采取最短的路线来使旋转工作，所以，如果你的对象是直的，你旋转到90度（弧度：π的一半），
                // 它将顺时针旋转。如果你的对象是直的，而你旋转到270度（弧度：π+π的一半），它将逆时针旋转，因为这是最小的可能动画。
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 5:
                // 重置
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear
            default:
                break
            }
        } completion: { finished in
            button.isHidden = false
        }


        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}

