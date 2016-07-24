//
//  RandomUserAPI.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/23.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import RxSwift

class RandomUserAPI {
    
    static let sharedAPI = RandomUserAPI()
    
    private init() {}
    
    func getExampleUserResultSet() -> Observable<[User]> {
        let url = NSURL(string: "http://api.randomuser.me/?results=20")!
        return NSURLSession.sharedSession().rx_JSON(url)
            .map { json in
                guard let json = json as? [String: AnyObject] else {
                    throw exampleError("Casting to directory failed")
                }
                
                return try self.parseJSON(json)
        }
    }
    
    private func parseJSON(json: [String: AnyObject]) throws -> [User] {
        guard let results = json["results"] as? [[String: AnyObject]] else {
            throw exampleError("Can't find results")
        }
        
        let userParsingError = exampleError("Can't parse user")
        
        let searchResults: [User] = try results.map { user in
            let name = user["name"] as? [String: String]
            let pictures = user["picture"] as? [String: String]
            
            guard let firstName = name?["first"],
                let lastName = name?["last"],
                let imageURL = pictures?["medium"] else {
                    throw userParsingError
            }
            
            let resultUser = User(firstName: firstName.capitalizedString, lastName: lastName.capitalizedString, imageURL: imageURL)
            
            return resultUser
        }
        
        return searchResults
    }
}