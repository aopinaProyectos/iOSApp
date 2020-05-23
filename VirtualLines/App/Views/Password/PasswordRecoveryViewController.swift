//
//  PasswordRecoveryViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/23/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PasswordRecoveryViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    
    let phoneNumber = AppInfo().phone
    let token = AppInfo().tokenPassword
    let disposeBag: DisposeBag = DisposeBag()
    
    var passwordText: String = ""
    var flagKeyboard: Bool = true
    var flagUseKeyBoard: Bool = false
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.becomeFirstResponder()
        hideKeyBoardWhenTap()
        applyLocalization()
        setupview()
    }
    
    //Se agrega esta funcion para los observadores del teclado
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func applyLocalization() {
        sendButton.setTitle(Message.ENTER.localized, for: .normal)
        instructionsLabel.text = Message.INSTRUCTIONSPR.localized
    }
    
    func setupview() {
        passwordField.borderWidth = 0
        passwordField.borderStyle = .none
    }
    
    func resetPassword() {
        let body = createBody()
        APIVirtualLines.resetPassword(body: body, number: phoneNumber).debug("APIVirtualLines.ResetPassword").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            print (dataResponse)
            AppInfo().password = self.passwordText
            UIStoryboard.loadMenu()
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["password"] = passwordText
        bodyCollection["token"] = token
        return bodyCollection
    }
    
    func getData() {
        passwordText = stringToCrypto(text: passwordField.text!)
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
    
    @IBAction func didTextEdit(_ sender: Any) {
        if passwordField.text?.count != 0 {
            sendButton.isEnabled = true
            sendButton.backgroundColor = kColorButtonActive
        }else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = kColorInactive
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        getData()
        resetPassword()
        UIStoryboard.loadMenu()
    }
    
    @IBAction func eyeAction(sender: AnyObject) {
        if(iconClick == true) {
            passwordButton.setImage(UIImage(named: "EyeClose"), for: .normal)
            passwordField.isSecureTextEntry = true
            passwordButton.isSelected = iconClick
        } else {
            passwordButton.setImage(UIImage(named: "EyeOpen"), for: .selected)
            passwordField.isSecureTextEntry = false
            passwordButton.isSelected = iconClick
        }
        iconClick = !iconClick
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
    
    
    
}
