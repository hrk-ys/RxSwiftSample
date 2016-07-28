//
//  WikipediaSearchCell.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class WikipediaSearchCell: UITableViewCell {
    @IBOutlet var titleOutlet: UILabel!
    @IBOutlet var URLOutlet: UILabel!
    @IBOutlet var imagesOutlet: UICollectionView!
    
    var disposeBag: DisposeBag?
    
    let imageService = DefaultImageService.sharedImageService
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imagesOutlet.registerNib(UINib(nibName: "WikipediaImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    var viewModel: SearchResultViewModel! {
        didSet {
            let disposeBag = DisposeBag()
            
            (viewModel?.title ?? Driver.just(""))
                .drive(self.titleOutlet.rx_text)
                .addDisposableTo(disposeBag)
            
            self.URLOutlet.text = viewModel.searchResult.URL.absoluteString ?? ""
            
            let reachabilityService = Dependencies.sharedDependencies.reachabilityService
            viewModel.imageURLs
                .drive(self.imagesOutlet.rx_itemsWithCellIdentifier("ImageCell", cellType: CollectionViewImageCell.self)) { [weak self] (_, URL, cell) in
                    cell.downloadableImage = self?.imageService.imageFromURL(URL, reachabilityService: reachabilityService) ?? Observable.empty()
                }.addDisposableTo(disposeBag)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = nil
    }
}
