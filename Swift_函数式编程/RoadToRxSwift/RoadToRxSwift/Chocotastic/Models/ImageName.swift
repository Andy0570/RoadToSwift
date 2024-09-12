//
//  ImageName.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import UIKit

enum ImageName: String {
    case amex
    case discover
    case mastercard
    case visa
    case unknownCard

    var image: UIImage? {
        guard let image = UIImage(named: rawValue) else {
            return nil
        }
        return image
    }
}
