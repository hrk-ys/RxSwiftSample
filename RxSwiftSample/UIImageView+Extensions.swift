//
//  UIImageView+Extensions.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/23.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func makeRoundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.borderWidth = radius
        self.layer.masksToBounds = true
    }
    
}