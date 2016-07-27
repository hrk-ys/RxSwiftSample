//
//  DownloadableImage.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

enum DownloadableImage {
    case Content(image:UIImage)
    case OfflinePlaceholder
}