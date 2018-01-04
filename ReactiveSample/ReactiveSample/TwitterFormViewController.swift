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

class TwitterFormViewController: UIViewController {

    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var userInputLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var labelText = Variable("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputTextField.rx
                          .text
                          .asDriver()
                          .map {
                            let count = 10
                            return "\(count - Int($0!.count))"
                          }
                          .drive(userInputLabel.rx.text)
                          .disposed(by: disposeBag)

        userInputTextField
                         .rx
                         .text
                         .map {
                            return $0 ?? ""
                         }
                        .bind(to: labelText)
                        .disposed(by: disposeBag)
        
        labelText
            .asObservable()
            .map {
               $0.count
            }
            .subscribe(onNext: {
                if $0 >= 5 &&  $0 <= 10 {
                    self.userInputLabel.textColor = UIColor.orange
                } else if $0 > 10 {
                    self.userInputLabel.textColor = UIColor.red
                } else {
                    self.userInputLabel.textColor = UIColor.green
                }
                
            })
            .disposed(by: disposeBag)
        
 
    
        
        
      }
    



}

