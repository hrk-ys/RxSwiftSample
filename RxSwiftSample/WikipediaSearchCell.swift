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
    
    
}
