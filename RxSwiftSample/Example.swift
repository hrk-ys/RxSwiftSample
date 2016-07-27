//
//  Example.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/23.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

let MB = 1024 * 1024

func exampleError(error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}