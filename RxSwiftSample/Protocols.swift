//
//  Protocols.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/21.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

enum ValidationResult {
    case OK(message: String)
    case Empty
    case Validationg
    case Failed(message: String)
}

protocol GitHubAPI {
    func usernameAvailable(username: String) -> Observable<Bool>
    func signup(username: String, password: String) -> Observable<Bool>
}

protocol GitHubValidationService {
    func validateUsername(username: String) -> Observable<ValidationResult>
    func validatePassword(password: String) -> ValidationResult
    func validateRepeatedPassword(password: String, repeatedPassword: String) -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .OK:
            return true
        default:
            return false
        }
    }
}
