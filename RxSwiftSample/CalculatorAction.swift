//
//  CalculatorAction.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/22.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

enum Action {
    case Clear
    case ChangeSign
    case Percent
    case Operation(Operator)
    case Equal
    case AddNumber(Character)
    case AddDot
}