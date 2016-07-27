//
//  UIImage+Extensions.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func forceLazyImageDecompression() -> UIImage {
        UIGraphicsBeginImageContext(CGSizeMake(1, 1))
        return self
    }
}