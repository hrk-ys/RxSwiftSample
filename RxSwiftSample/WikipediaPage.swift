//
//  WikipediaPage.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import RxSwift

struct WikipediaPage {
    let title: String
    let text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    // tedious parsing part
    static func parseJSON(json: NSDictionary) throws -> WikipediaPage {
        guard let title = json.valueForKey("parse")?.valueForKey("title") as? String,
            let text = json.valueForKey("parse")?.valueForKey("text")?.valueForKey("*") as? String else {
                throw apiError("Error parsing page content")
        }
        
        return WikipediaPage(title: title, text: text)
    }
}