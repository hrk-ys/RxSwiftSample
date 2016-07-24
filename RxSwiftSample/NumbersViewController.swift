//
//  NumbersViewController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/20.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class NumbersViewController: ViewController
{
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(number1.rx_text, number2.rx_text, number3.rx_text) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map{ $0.description }
            .bindTo(result.rx_text)
            .addDisposableTo(disposeBag)
    }
}
