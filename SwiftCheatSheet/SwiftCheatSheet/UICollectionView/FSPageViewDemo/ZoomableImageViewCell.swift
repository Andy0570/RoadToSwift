//
//  ZoomableImageViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/18.
//

import FSPagerView

class ZoomableImageViewCell: FSPagerViewCell {
//    private let scrollImageView: UIImageView = {
//        let imageView = UIImageView()
//        // imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = false
//        return imageView
//    }()
//
//    private let imageScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.clipsToBounds = false
//        return scrollView
//    }()

    private let imageScrollView: PanZoomImageView = {
        let scrollView = PanZoomImageView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = false
        return scrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)


        contentView.backgroundColor = .white
        contentView.clipsToBounds = false

//        imageScrollView.delegate = self
//        contentView.addSubview(imageScrollView)
//        imageScrollView.addSubview(scrollImageView)

        contentView.addSubview(imageScrollView)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            imageScrollView.widthAnchor.constraint(equalTo: widthAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: heightAnchor),
            imageScrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageScrollView.centerYAnchor.constraint(equalTo: centerYAnchor)

//            imageScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageScrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            imageScrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            imageScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

//            scrollImageView.widthAnchor.constraint(equalTo: imageScrollView.widthAnchor),
//            scrollImageView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
//            scrollImageView.centerXAnchor.constraint(equalTo: imageScrollView.centerXAnchor),
//            scrollImageView.centerYAnchor.constraint(equalTo: imageScrollView.centerYAnchor)
        ])
    }

    func setImage(image: UIImage?) {
        // scrollImageView.image = image

        imageScrollView.imageName = "1.jpg"
//        if let image = image {
//            setMinZoomScaleForImageSize(image.size)
//        }
    }

//    // 计算并设置 UIScrollView 的最小缩放比例
//    private func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
//        let widthScale = contentView.frame.width / imageSize.width
//        let heightScale = contentView.frame.height / imageSize.height
//        let minScale = min(widthScale, heightScale)
//
//        // Scale the image down to fit in the view
//        imageScrollView.minimumZoomScale = minScale
//        imageScrollView.zoomScale = minScale
//
//        // Set the image frame size after scaling down
//        let imageWidth = imageSize.width * minScale
//        let imageHeight = imageSize.height * minScale
//        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
//        scrollImageView.frame = newImageFrame
//
//        centerImage()
//    }
//
//    // 将图片放在视图的中心
//    private func centerImage() {
//        let imageViewSize = scrollImageView.frame.size
//        let scrollViewSize = contentView.frame.size
//        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
//        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
//
//        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
//    }
}

// extension ZoomableImageViewCell: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        centerImage()
//    }
// }
