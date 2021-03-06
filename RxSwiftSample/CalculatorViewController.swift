//
//  CalculatorViewController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/22.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class CalculatorViewController : ViewController {
    
    @IBOutlet weak var lastSignLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var allClearButton: UIButton!
    @IBOutlet weak var changeSignButton: UIButton!
    @IBOutlet weak var percentButton: UIButton!
    
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    
    @IBOutlet weak var dotButton: UIButton!
    
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    
    override func viewDidLoad() {
        
        let commands:[Observable<Action>] = [
            allClearButton.rx_tap.map { _ in .Clear },
        
            changeSignButton.rx_tap.map { _ in .ChangeSign },
            percentButton.rx_tap.map { _ in .Percent },
            
            divideButton.rx_tap.map { _ in .Operation(.Division) },
            multiplyButton.rx_tap.map { _ in .Operation(.Multiplication) },
            minusButton.rx_tap.map { _ in .Operation(.Subtraction) },
            plusButton.rx_tap.map { _ in .Operation(.Addition) },
            
            equalButton.rx_tap.map { _ in .Equal },
            
            dotButton.rx_tap.map { _ in .AddDot },
            
            zeroButton.rx_tap.map { _ in .AddNumber("0") },
            oneButton.rx_tap.map { _ in .AddNumber("1") },
            twoButton.rx_tap.map { _ in .AddNumber("2") },
            threeButton.rx_tap.map { _ in .AddNumber("3") },
            fourButton.rx_tap.map { _ in .AddNumber("4") },
            fiveButton.rx_tap.map { _ in .AddNumber("5") },
            sixButton.rx_tap.map { _ in .AddNumber("6") },
            sevenButton.rx_tap.map { _ in .AddNumber("7") },
            eightButton.rx_tap.map { _ in .AddNumber("8") },
            nineButton.rx_tap.map { _ in .AddNumber("9") }
        ]
        
        commands
            .toObservable()
            .merge()
            .debug("merge")
            .scan(CalculatorState.CLEAR_STATE) { a, x in
                return a.transformState(x)
            }
            .debug("transform")
            .subscribeNext { [weak self] (calState) in
                self?.resultLabel.text = self?.prettyFormat(calState.inScreen)
            }
            .addDisposableTo(disposeBag)
    
    }
    
    func prettyFormat(str: String) -> String {
        if str.hasSuffix(".0") {
            return str.substringToIndex(str.endIndex.predecessor().predecessor())
        }
        return str
    }
}