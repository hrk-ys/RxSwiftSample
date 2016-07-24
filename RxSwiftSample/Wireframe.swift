//
//  Wireframe.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/21.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol Wireframe {
    func openURL(URL: NSURL)
    func promptFor<Action: CustomStringConvertible>(message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

class DefaultWireframe: Wireframe {
    static let sharedInstance = DefaultWireframe()
    
    func openURL(URL: NSURL) {
        UIApplication.sharedApplication().openURL(URL)
    }
    
    private static func rootViewController() -> UIViewController {
        return UIApplication.sharedApplication().keyWindow!.rootViewController!
    }
    
    static func presentAlert(message: String) {
        let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel) { _ in
            })
        rootViewController().presentViewController(alertView, animated: true, completion: nil)
    }
    
    func promptFor<Action : CustomStringConvertible>(message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        
        return Observable.create { observer in
            
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .Cancel) { _ in
                observer.on(.Next(cancelAction))
            })
            
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .Default) { _ in
                    observer.on(.Next(action))
                })
            }
            
            DefaultWireframe.rootViewController().presentViewController(alertView, animated: true, completion: nil)
            
            return AnonymousDisposable {
                alertView.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}