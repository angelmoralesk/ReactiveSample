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

class ReactMenuViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    lazy var data : [String] = {
        var items = ["TextField Twitter"]
        return items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.just(data)
                  .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                                cell.textLabel?.text = "\(element)"
                  }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
                  .subscribe(onNext: {
                    print($0)
                  }).disposed(by: disposeBag)
        
        
    }


}
