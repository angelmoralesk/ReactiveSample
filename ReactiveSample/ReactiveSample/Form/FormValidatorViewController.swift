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
    
    func prepareUI() {
        
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
        
    }
    
    func prepareValidations() {
        
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
            .map { self.validate(email: $0!) }
        
        let shouldShowSecondLastName = Observable.combineLatest(nameValidation, lastNameValidation) {nameValidation, lastNameValidation -> Bool in
            return nameValidation && lastNameValidation ? false : true
        }
        
        // Show secondLastNameTextField if name and last name are typed
        shouldShowSecondLastName
            .bind(to: secondLastNameTextField.rx.isHidden)
            .disposed(by: disposeBag)
        
        let shouldEnableUserButton = Observable.combineLatest(shouldShowSecondLastName, addressValidation, emailValidation) { shouldShowSecondLastName, addressValidation, emailValidation in
            return !shouldShowSecondLastName && addressValidation && emailValidation
        }
        
        // Enable button if textFields are typed
        shouldEnableUserButton
            .bind(to: validateButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        // Show button if textFields are typed
        shouldEnableUserButton
            .map{
                !$0
            }
            .bind(to: validateButton.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        prepareValidations()
        
        buildParamsFromTappedButton()
    }
    
    func buildParamsFromTappedButton() {
        
        let buttonTapped = PublishSubject<String>()
        
        validateButton.rx.tap
            .map {
                "name: \(self.nameTextField.text!), " +
                "lastName: \(self.lastNameTextField.text!), " +
                "secondLastName: \(self.secondLastNameTextField.text!), " +
                "address: \(self.addressTextField.text!), " +
                "email: \(self.emailTextField.text!)"
            }
            .bind(to: buttonTapped)
            .disposed(by: disposeBag)
        
        buttonTapped.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
    }
    
    func validate(email : String) -> Bool {
        return email.contains("@")
    }


}
