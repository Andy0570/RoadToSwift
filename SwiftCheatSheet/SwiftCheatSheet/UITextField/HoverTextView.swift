//
//  HoverTextView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/26.
//

import UIKit

protocol SendTextDelegate: AnyObject {
    func onSendText(text: String)
}

protocol HoverTextViewDelegate: AnyObject {
    func hoverTextViewStateChange(isHover: Bool)
}

final class HoverTextView: UIView {
//    private enum Constants {
//        static let leftInset: CGFloat = 40
//        static let rightInset: CGFloat = 100
//        static let topBottomInset: CGFloat = 50
//    }

    weak var delegate: SendTextDelegate?
    weak var hoverDelegate: HoverTextViewDelegate?
    var lengthLimit: Int = 0 // 默认值为0，不限制输入字数
    private var horizontalStackViewBottom: NSLayoutConstraint!

    /// 水平布局的堆栈视图
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        let largeFont = UIFont.systemFont(ofSize: 16)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        imageView.image = UIImage(systemName: "highlighter", withConfiguration: configuration)
        // 提高 imageView 的内容抗拉伸优先级，使其保持其固有内容大小
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var textView: KMPlaceholderTextView = {
        let textView = KMPlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        // textView.textColor = .white
        textView.returnKeyType = .send
        // textView.backgroundColor = .clear

        textView.placeholder = "我要评论"
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        if #available(iOS 13.0, *) {
            button.backgroundColor = UIColor.tertiarySystemGroupedBackground
        } else {
            button.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        }
        button.setTitle("发送", for: .normal)
        // button.setImage(UIImage(named: "ic30RedSend"), for: .normal)
        // button.setImage(UIImage(named: "ic30WhiteSend"), for: .disabled)

        button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    /// 分割线
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // view.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        view.backgroundColor = .black
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(separatorView)
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(iconImageView)
        horizontalStackView.addArrangedSubview(textView)
        horizontalStackView.addArrangedSubview(sendButton)

        horizontalStackViewBottom =  horizontalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            horizontalStackView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            horizontalStackViewBottom
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    // MARK: - Actions

    @objc func sendButtonTapped(_ sender: UIButton) {
        delegate?.onSendText(text: textView.text)
        textView.text = nil
        textView.resignFirstResponder()
    }
}

extension HoverTextView {
    @objc dynamic func keyboardWillShow(_ notification: Notification) {
        // backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        animateWithKeyboard(notification: notification) { [weak self] keyboardFrame in
            self?.horizontalStackViewBottom.constant -= keyboardFrame.height
        }

        hoverDelegate?.hoverTextViewStateChange(isHover: true)
    }

    @objc dynamic func keyboardWillHide(_ notification: Notification) {
        // backgroundColor = .clear
        animateWithKeyboard(notification: notification) { [weak self] keyboardFrame in
            self?.horizontalStackViewBottom.constant += keyboardFrame.height
        }

        hoverDelegate?.hoverTextViewStateChange(isHover: false)
    }

    func animateWithKeyboard(notification: Notification, animations: ((_ keyboardFrame: CGRect) -> Void)?) {
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
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)

            // Required to trigger NSLayoutConstraint changes to animate
            self?.layoutIfNeeded()
        }

        // Start the animation
        animator.startAnimation()
    }
}

extension HoverTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 点击键盘中的「发送」按钮
        if text == "\n" {
            delegate?.onSendText(text: textView.text)
            return false
        }

        if lengthLimit == 0 {
            return true
        }

        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= lengthLimit
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.hasText {
            sendButton.isUserInteractionEnabled = true
        } else {
            sendButton.isUserInteractionEnabled = false
        }
    }
}
