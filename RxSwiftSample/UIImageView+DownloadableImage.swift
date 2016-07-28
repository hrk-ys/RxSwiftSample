//
//  UIImageView+DownloadableImage.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/28.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension UIImageView {
    
    var rxex_downloadableImage: AnyObserver<DownloadableImage>{
        return self.rxex_downloadableImageAnimated(nil)
    }
    
    func rxex_downloadableImageAnimated(transitionType: String?) -> AnyObserver<DownloadableImage> {
        
        return UIBindingObserver(UIElement: self) { imageView, image in
            for subview in imageView.subviews {
                subview.removeFromSuperview()
            }
            
            switch image {
            case .Content(image: let image):
                imageView.rx_image.onNext(image)
            case .OfflinePlaceholder:
                let label = UILabel(frame: imageView.bounds)
                label.font = UIFont.systemFontOfSize(35)
                label.text = "⚠️"
                imageView.addSubview(label)
            }
        }.asObserver()
    }
}