//
//  LoginRecoveryPasswordViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/22/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class LoginRecoveryPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    
    var phoneNumber: String = ""
    var email: String = ""
    var emailText: String = ""
    
    var flagKeyboard: Bool = true
    var flagUseKeyBoard: Bool = false
    
    let disposeBag: DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyLocalization()
        setupView()
        emailField.becomeFirstResponder()
        hideKeyBoardWhenTap()
        phoneNumber = AppInfo().phone
        getEmail()
    }
    
    //Se agrega esta funcion para los observadores del teclado
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func applyLocalization() {
        instructionLabel.text = Message.INSTRUCTIONSRP.localized
        buttonSend.setTitle(Message.SEND.localized, for: .normal)
        emailField.placeholder = Message.PHDEMAIL.localized
    }
    
    func setupView() {
        emailField.borderWidth = 0
        emailField.borderStyle = .none
    }
    
    func setupEmail() {
        emailLabel.textColor = kColorActive
        emailLabel.text = self.email
    }
    
    func getEmail() {
        APIVirtualLines.getEmailRecover(number: phoneNumber).debug("APIVirtualLines.GetEmailRecovery").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.email = dataResponse.email
            self.setupEmail()
        }, onError: {(error) in
            print("onError")
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func sendEmail() {
        let body = createBody()
        APIVirtualLines.sendEmail(body: body, number: phoneNumber).debug("APIVirtualLines.SendEmail").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            AppInfo().tokenPassword = dataResponse.token
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["email"] = emailText
        return bodyCollection
    }
    
    func getData() {
        emailText = emailField.text!
    }
    
    //Ajuste del offset de los botones
    func adjustButton(show:Bool, hide:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        var changeInHeightFinal = CGFloat(0.0)
        var keybrdHeight = CGFloat(0.0)
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keybrdHeight = keyboardHeight
        }
        
        if (show || (hide && !show)) {
            changeInHeightFinal = ((keybrdHeight) * (show ? 1 : -1))
        }
        if show {
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                self.bottomButton.constant = changeInHeightFinal
                
            })
        }else if hide {
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                self.bottomButton.constant += changeInHeightFinal
                
            })
        }
    }
    
    func isValidEmailAddress(email: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    //Funciones para los observadores del teclado
    @objc func keyboardShow(notification: NSNotification) {
        if flagKeyboard {
            adjustButton(show: flagKeyboard, hide: false, notification: notification)
        }
        flagKeyboard = false
        self.flagUseKeyBoard = true
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        flagKeyboard = true
        if self.flagUseKeyBoard {
            adjustButton(show: false, hide:true, notification: notification)
            
        } else
        {
            adjustButton(show: false, hide:false, notification: notification)
        }
        self.flagUseKeyBoard = false
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        getData()
        sendEmail()
    }
    
    @IBAction func didTextEdit(_ sender: Any) {
        if isValidEmailAddress(email: emailField.text!) {
            buttonSend.isEnabled = true
            buttonSend.backgroundColor = kColorButtonActive
        }
    }
}
