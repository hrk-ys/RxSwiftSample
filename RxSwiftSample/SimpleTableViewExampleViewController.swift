//
//  SimpleTableViewExampleViewController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/23.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

class SimpleTableViewExampleViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
            ])
        
        items.bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .addDisposableTo(disposeBag)
        
        tableView
            .rx_modelSelected(String)
            .subscribeNext { (value) in
                DefaultWireframe.presentAlert("Tapped `\(value)`")
            }
            .addDisposableTo(disposeBag)
        
        tableView
            .rx_itemAccessoryButtonTapped
            .subscribeNext { (indexPath) in
                DefaultWireframe.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            }
            .addDisposableTo(disposeBag)
        
        tableView
            .rx_itemSelected
            .subscribeNext { [weak self] (value) in
                self?.tableView.deselectRowAtIndexPath(value, animated: true)
            }
            .addDisposableTo(disposeBag)
    }
}