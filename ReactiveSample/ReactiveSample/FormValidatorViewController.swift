//
//  FormValidatorViewController.swift
//  ReactiveSample
//
//  Created by Angel Jesse Morales Karam Kairuz on 03/01/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FormValidatorViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var secondLastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.rx.controlEvent([.editingDidEnd])
                        .asObservable()
                        .subscribe(onNext: { [unowned self] in
                            self.helloLabel.text = "Hola \(self.nameTextField.text!)"
                        })
                        .disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent([.editingDidBegin, .editingChanged])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.helloLabel.text = ""
            })
            .disposed(by: disposeBag)
    
        let nameValidation = nameTextField.rx.text
                            .map({!$0!.isEmpty})
                            .share(replay: 1)
    
        let lastNameValidation = lastNameTextField.rx.text
                                              .map({!$0!.isEmpty})
                                              .share(replay: 1)
        
        let addressValidation = addressTextField.rx.text
                                                   .map({!$0!.isEmpty})
                                                   .share(replay: 1)
        
        let emailValidation = emailTextField.rx.text
                                                .map({!$0!.isEmpty})
                                                .share(replay: 1)
        
        let shouldShowSecondLastName = Observable.combineLatest(nameValidation, lastNameValidation) {nameValidation, lastNameValidation -> Bool in
            return nameValidation && lastNameValidation ? false : true
        }
        
        shouldShowSecondLastName
            .bind(to: secondLastNameTextField.rx.isHidden)
            .disposed(by: disposeBag)
        
        let shouldShowValidateButton = Observable.combineLatest(shouldShowSecondLastName, addressValidation, emailValidation) { shouldShowSecondLastName, addressValidation, emailValidation in
            
            return !shouldShowSecondLastName && addressValidation && emailValidation ? false : true
            
        }
        
        
       shouldShowValidateButton
            .bind(to: validateButton.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    
    func validate(name : String) -> Bool {
        return name.count >= 3
    }


}
