//
//  SimpleValidationViewController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/20.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let minimalUsernameLength = 5
let minimalPasswordLength = 5

class SimpleValidationViewController : ViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameOutlet.rx_text

            .map { $0.characters.count >= minimalUsernameLength }
            .shareReplay(1)

        let passwordValid = passwordOutlet.rx_text
            .map{ $0.characters.count >= minimalPasswordLength }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
        .shareReplay(1)
        
        usernameValid
            .bindTo(passwordOutlet.rx_enabled)
            .addDisposableTo(disposeBag)
        
        usernameValid
            .bindTo(usernameValidOutlet.rx_hidden)
            .addDisposableTo(disposeBag)

        
        passwordValid
            .bindTo(passwordValidOutlet.rx_hidden)
            .addDisposableTo(disposeBag)
        
        everythingValid
            .bindTo(doSomethingOutlet.rx_enabled)
            .addDisposableTo(disposeBag)
        
        doSomethingOutlet.rx_tap
            .subscribeNext { [weak self] in self?.showAlert() }
            .addDisposableTo(disposeBag)
    }
    
    func showAlert() {
        let ac = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self .presentViewController(ac, animated: true, completion: nil)

    }
}
