//
//  CollectionViewImageCell.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/28.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

public class CollectionViewImageCell: UICollectionViewCell {
    @IBOutlet var imageOutlet: UIImageView!
    
    var disposeBag: DisposeBag?
    
    var downloadableImage: Observable<DownloadableImage>?{

        didSet {
            let disposeBag = DisposeBag()

            self.downloadableImage?
                .asDriver(onErrorJustReturn: DownloadableImage.OfflinePlaceholder)
                .drive(imageOutlet.rxex_downloadableImageAnimated(kCATransitionFade))
                .addDisposableTo(disposeBag)
            
            self.disposeBag = disposeBag
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = nil
    }
}