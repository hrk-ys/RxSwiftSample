//
//  CalculatorState.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/22.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

struct CalculatorState {
    
    static let CLEAR_STATE = CalculatorState(previouseNumber: nil, action: .Clear, curretnNumber: "0", inScreen: "0", replace: true)
    
    let previouseNumber: String! // 前の数字
    let action: Action
    let curretnNumber: String!
    let inScreen: String
    let replace: Bool
}

extension CalculatorState {
    func transformState(x: Action) -> CalculatorState {
        switch x {
        case .Clear:
            return CalculatorState.CLEAR_STATE
        case .AddNumber(let c):
            return addNumber(c)
        case .AddDot:
            return addDot()
        case .ChangeSign:
            let d = "\(-Double(self.inScreen)!)"
            return CalculatorState(previouseNumber: previouseNumber, action: action, curretnNumber: d, inScreen: d, replace: true)
        case .Percent:
            let d = "\(Double(self.inScreen)!/100)"
            return CalculatorState(previouseNumber: previouseNumber, action: action, curretnNumber: d, inScreen: d, replace: true)
        case .Operation(let o):
            return performOperation(o)
        case .Equal:
            return performEqual()
        }
    }
    
    func addNumber(char: Character) -> CalculatorState {
        let cn = curretnNumber == nil || replace ? String(char) : curretnNumber + String(char)
        return CalculatorState(previouseNumber: previouseNumber, action: action, curretnNumber: cn, inScreen: cn, replace: false)
    }
    
    func addDot() -> CalculatorState {
        let cn = inScreen.rangeOfString(".") == nil ? curretnNumber + "." : curretnNumber
        return CalculatorState(previouseNumber: previouseNumber, action: action, curretnNumber: cn, inScreen: cn, replace: false)
    }
    
    func performOperation(o: Operator) -> CalculatorState{
        
        if previouseNumber == nil {
            return CalculatorState(previouseNumber: curretnNumber, action: .Operation(o), curretnNumber: nil, inScreen: curretnNumber, replace: true)
        }
        else {
            let previous = Double(previouseNumber)!
            let current  = Double(curretnNumber)!
            
            switch action {
            case .Operation(let op):
                var result:String!
                switch op {
                case .Addition:
                    result = "\(previous + current)"
                case .Subtraction:
                    result = "\(previous - current)"
                case .Multiplication:
                    result = "\(previous * current)"
                case .Division:
                    result = "\(previous / current)"
                }
                return CalculatorState(previouseNumber: result, action: .Operation(o), curretnNumber: nil, inScreen: result, replace: true)
            default:
                return CalculatorState(previouseNumber: nil, action: .Operation(o), curretnNumber: curretnNumber, inScreen: inScreen, replace: true)
            }
        }
    }
    
    func performEqual() -> CalculatorState {
        return CalculatorState.CLEAR_STATE
    }
}