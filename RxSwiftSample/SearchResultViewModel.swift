//
//  SearchResultViewModel.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/27.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultViewModel {
    
    let searchResult: WikipediaSearchResult

    var title: Driver<String>
    var imageURLs: Driver<[NSURL]>
    
    let API = DefaultWikipediaAPI.sharedAPI
    let $: Dependencies = Dependencies.sharedDependencies
    
    init(searchResult: WikipediaSearchResult) {
        self.searchResult = searchResult
        
        self.title = Driver.never()
        self.imageURLs = Driver.never()
        
        
        let URLs = configureImageURLs()
        
        self.imageURLs = URLs.asDriver(onErrorJustReturn: [])
        self.title = configureTitle(URLs).asDriver(onErrorJustReturn: "Error during fetching")
    }
    
    func configureTitle(imageURLs: Observable<[NSURL]>) -> Observable<String> {
        let searchResult = self.searchResult
        
        let loadingValue: [NSURL]? = nil
        
        return imageURLs
            .map(Optional.init)
            .startWith(loadingValue)
            .map { URLs in
                if let URLs = URLs {
                    return "\(searchResult.title) (\(URLs.count)) pictures)"
                }
                else {
                    return "\(searchResult.title) loading ..."
                }
            }
            .retryOnBecomesReachable("⚠️ Service offline ⚠️", reachabilityService: $.reachabilityService)
    }
    
    func configureImageURLs() -> Observable<[NSURL]> {
        let searchResult = self.searchResult
        
        return API.articleContent(searchResult)
            .observeOn($.backgroundWorkScheduler)
            .map { page in
                do {
                    return try parseImageURLsfromHTML(page.text)
                } catch {
                    return []
                }
            }
    }
}