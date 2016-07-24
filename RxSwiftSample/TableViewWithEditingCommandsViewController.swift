//
//  TableViewWithEditingCommandsViewController.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/23.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources


struct TableViewEditingCommandsViewModel {
    let favoriteUsers: [User]
    let users: [User]
    
    func executeCommand(command: TableViewEditingCommand) -> TableViewEditingCommandsViewModel {
        switch command {
        case let .SetUsers(users):
            return TableViewEditingCommandsViewModel(favoriteUsers: favoriteUsers, users: users)
        case let .SetFavoriteUsers(favoriteUsers):
            return TableViewEditingCommandsViewModel(favoriteUsers: favoriteUsers, users: users)
        }
    }
}


enum TableViewEditingCommand {
    case SetUsers(users: [User])
    case SetFavoriteUsers(favoriteUsers: [User])
    
}

class TableViewWithEditingCommandsViewController: ViewController, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = TableViewWithEditingCommandsViewController.configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let superMan =  User(
            firstName: "Super",
            lastName: "Man",
            imageURL: "http://nerdreactor.com/wp-content/uploads/2015/02/Superman1.jpg"
        )
        
        let watMan = User(firstName: "Wat",
                          lastName: "Man",
                          imageURL: "http://www.iri.upc.edu/files/project/98/main.GIF"
        )
        
        let loadFavoriteUsers = RandomUserAPI.sharedAPI
            .getExampleUserResultSet()
            .map(TableViewEditingCommand.SetUsers)
        
        let initialLoadCommand = Observable.just(TableViewEditingCommand.SetFavoriteUsers(favoriteUsers: [superMan, watMan]))
            .concat(loadFavoriteUsers)
            .observeOn(MainScheduler.instance)
        
        let initalState = TableViewEditingCommandsViewModel(favoriteUsers: [], users: [])
        
        let viewModel = Observable.of(initialLoadCommand)
            .merge()
            .scan(initalState) { $0.executeCommand($1) }
            .shareReplay(1)
        
        viewModel
            .map {
                [
                    SectionModel(model: "Favorite Users", items: $0.favoriteUsers),
                    SectionModel(model: "Normal Users", items: $0.users)
                ]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        
        tableView.rx_itemSelected
            .withLatestFrom(viewModel) { i, viewModel in
                let all = [viewModel.favoriteUsers, viewModel.users]
                return all[i.section][i.row]
            }
            .subscribeNext { [weak self] user in
                self?.showDetailsForUser(user)
            }
            .addDisposableTo(disposeBag)
        
    }
    
    private func showDetailsForUser(user: User) {
    }
    
    static func configureDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, User>> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>()
        
        dataSource.configureCell = { (_, tv, ip, user: User) in
            let cell = tv.dequeueReusableCellWithIdentifier("Cell")!
            cell.textLabel?.text = user.firstName + " " + user.lastName
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            return dataSource.sectionAtIndex(sectionIndex).model
        }
        
        dataSource.canEditRowAtIndexPath = { (ds, ip) in
            return true
        }
        
        dataSource.canMoveRowAtIndexPath = { _ in
            return true
        }
        
        return dataSource
        
    }
    
}
