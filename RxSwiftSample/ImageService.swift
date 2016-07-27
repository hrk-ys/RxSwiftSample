//
//  ImageService.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

protocol ImageService {
    func imageFromURL(URL: NSURL, reachabilityService: ReachabilityService) -> Observable<DownloadableImage>
}

class DefaultImageService: ImageService {
    
    static let sharedImageService = DefaultImageService()
    
    let $: Dependencies = Dependencies.sharedDependencies
    
    private let _imageCache = NSCache()
    
    private let _imageDataCache = NSCache()
    
    let loadingImage = ActivityIndicator()
    
    private init() {
        _imageDataCache.totalCostLimit = 10 * MB
        
        _imageCache.countLimit = 20
    }
    
    
    private func decodeImage(imageData: NSData) -> Observable<UIImage> {
        return Observable.just(imageData)
            .observeOn($.backgroundWorkScheduler)
            .map { data in
                guard let image = UIImage(data: imageData) else {
                    throw apiError("Decoding image error")
                }
                return image.forceLazyImageDecompression()
            }
    }
    
    private func _imageFromURL(URL: NSURL) -> Observable<UIImage> {
        return Observable.deferred {
            let mybeImage = self._imageCache.objectForKey(URL) as? UIImage
            
            let decodedImage: Observable<UIImage>
            
            if let image = mybeImage {
                decodedImage = Observable.just(image)
            } else {
                let cachedData = self._imageDataCache.objectForKey(URL) as? NSData
                
                if let cachedData = cachedData {
                    decodedImage = self.decodeImage(cachedData)
                }
                else {
                    decodedImage = self.$.URLSession.rx_data(NSURLRequest(URL: URL))
                        .doOnNext { data in
                            self._imageDataCache.setObject(data, forKey: URL)
                        }
                        .flatMap(self.decodeImage)
                        .trackActivity(self.loadingImage)
                }
            }
            
            return decodedImage.doOnNext { image in
                self._imageCache.setObject(image, forKey: URL)
            }
        }
    }
    
    func imageFromURL(URL: NSURL, reachabilityService: ReachabilityService) -> Observable<DownloadableImage> {
        return _imageFromURL(URL)
            .map { DownloadableImage.Content(image: $0) }
            .retryOnBecomesReachable(DownloadableImage.OfflinePlaceholder, reachabilityService: reachabilityService)
            .startWith(.Content(image: UIImage()))
    }
}