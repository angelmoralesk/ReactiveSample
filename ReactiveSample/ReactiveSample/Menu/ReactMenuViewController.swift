//
//  ReactMenuViewController.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 31/12/17.
//  Copyright © 2017 TheKairuz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GitHubServices

class ReactMenuViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    lazy var data : [String] = {
        var items = ["Twitter",
                     "Form Validator",
                     "Image Collection"]
        return items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.just(data)
                  .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                                cell.textLabel?.text = "\(element)"
                  }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [unowned self] elem in
                self.performSegue(withIdentifier: elem.lowercased(), sender: self)
            },onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
            
        GitHubProvider.fetchRepositories(userId: "ctime95") { (status) in
            
        }
        
    }
    

}
