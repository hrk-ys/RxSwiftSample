//
//  GitHubSignupViewController1.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/21.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GitHubSignupViewController1: ViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var signingUpOulet: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = GithubSignupViewModel1 (
            input: (
                username: usernameOutlet.rx_text.asObservable(),
                password: passwordOutlet.rx_text.asObservable(),
                repeatedPassword: repeatedPasswordOutlet.rx_text.asObservable(),
                loginTaps: signupOutlet.rx_tap.asObservable()
            ),
            dependency: (
                // github api
                API: GitHubDefaultAPI.sharedAPI,
                // github username, password, confirm
                validationService: GitHubDefaultValidationService.sharedValidationService,
                // その他のalertなどの処理
                wireframe: DefaultWireframe.sharedInstance
            )
        )
        
        // ログイン処理実行できる！
        viewModel.signupEnabled
            .subscribeNext { [weak self] valid in
                self?.signupOutlet.enabled = valid
                self?.signupOutlet.alpha = valid ? 1.0 : 0.5
            }
            .addDisposableTo(disposeBag)
        
        viewModel.validatedUsername
            .bindTo(usernameValidationOutlet.ex_validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.validatedPassword
            .bindTo(passwordValidationOutlet.ex_validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.validatedPasswordRepeated
            .bindTo(repeatedPasswordValidationOutlet.ex_validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.signingIn
            .bindTo(signingUpOulet.rx_animating)
            .addDisposableTo(disposeBag)
        
        viewModel.signedIn
            .subscribeNext { (signedIn) in
                print("User signned in \(signedIn)")
            }
            .addDisposableTo(disposeBag)
        
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx_event
            .subscribeNext { [weak self] _ in
                self?.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
        
        view.addGestureRecognizer(tapBackground)
    }
    
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if let parent = parent {
            assert(parent.isKindOfClass(UINavigationController), "Please read comments")
        }
        else {
            self.disposeBag = DisposeBag()
        }
    }
    
}