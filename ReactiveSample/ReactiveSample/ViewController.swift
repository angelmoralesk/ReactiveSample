//
//  ViewController.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 29/12/17.
//  Copyright © 2017 TheKairuz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var userInputLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputTextField.rx
                          .text
                          .asDriver()
                          .drive(userInputLabel.rx.text)
                          .disposed(by: disposeBag)
        
    }



}

