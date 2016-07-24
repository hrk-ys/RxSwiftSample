//
//  ImagePickerController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/22.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

class ImagePickerController : ViewController {
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var cropButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        cameraButton.rx_tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx_createWithParent(self) { picker in
                    picker.sourceType = .Camera
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx_didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .bindTo(imageView.rx_image)
            .addDisposableTo(disposeBag)
        
        galleryButton.rx_tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx_createWithParent(self) { picker in
                    picker.sourceType = .PhotoLibrary
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx_didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .bindTo(imageView.rx_image)
            .addDisposableTo(disposeBag)
        
        cropButton.rx_tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx_createWithParent(self) { picker in
                    picker.sourceType = .PhotoLibrary
                    picker.allowsEditing = true
                    }
                    .flatMap { $0.rx_didFinishPickingMediaWithInfo }
                    .take(1)
            }
            .map { info in
                return info[UIImagePickerControllerEditedImage] as? UIImage
            }
            .bindTo(imageView.rx_image)
            .addDisposableTo(disposeBag)
    }
}