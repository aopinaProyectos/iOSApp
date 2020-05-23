//
//  LoginPasswordViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/22/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LoginPasswordViewController: UIViewController {
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonPassword: UIButton!
    @IBOutlet weak var buttonForget: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    
    var phoneNumber = ""
    var iconClick = true
    var flagKeyboard: Bool = true
    var flagUseKeyBoard: Bool = false
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyLocalization()
        setupView()
        phoneNumber = AppInfo().phone
        passwordField.becomeFirstResponder()
        hideKeyBoardWhenTap()
    }
    
    //Se agrega esta funcion para los observadores del teclado
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func applyLocalization() {
        welcomeLabel.text = checkGreeting()
        
    }
    
    func setupView() {
        welcomeLabel.textColor = kColorActive
        passwordField.borderWidth = 0
        passwordField.borderStyle = .none
        passwordField.isSecureTextEntry = true
        errorLabel.isHidden = true
        passwordField.attributedPlaceholder = NSAttributedString(string: "",attributes: [NSAttributedString.Key.foregroundColor: kColorPlaceHolder])
        passwordField.textColor = kColorText
    }
    
    func setupError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        errorLabel.textColor = kColorError
    }
    
    func checkGreeting() -> String {
        var text = ""
        var currentTimeOfDay = ""
        let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
        if hour >= 0 && hour < 12 {
            currentTimeOfDay = Message.MORNING.localized
        } else if hour >= 12 && hour < 17 {
            currentTimeOfDay = Message.AFTERNOON.localized
        } else if hour >= 17 {
            currentTimeOfDay = Message.EVENING.localized
        }
        text = currentTimeOfDay + " " + Message.PASSGREETING.localized
        return text
    }
    
    func getPassword() -> String {
        var password = ""
        password = stringToCrypto(text: passwordField.text!)
        return password
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["userName"] = phoneNumber
        bodyCollection["password"] = getPassword()
        return bodyCollection
    }
    
    func checkGlobalMessages(message: String){
        if message != "" {
            print("Show Alert")
        }
    }
    
    func login() {
        let parameters = createBody()
        let body = parameters
        APIVirtualLines.login(body: body).debug("APIVirtualLines.Login").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.checkGlobalMessages(message: dataResponse.globalMsg)
            if dataResponse.response?.code == 210 {
                AppInfo().userName = self.phoneNumber
                AppInfo().password = self.getPassword()
                if dataResponse.category == 2 {
                    AppInfo().isUserHost = true
                    UIStoryboard.loadMenuHost()
                }else {
                    AppInfo().isUserHost = false
                    UIStoryboard.loadMenu()
                }
            }
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.ErrorPassword(let error):
                self.setupError(message: error.message)
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
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
    
//    Metodos para evaluar el textField y activar los botones
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        errorLabel.isHidden = true
        if passwordField.text?.count != 0 {
            buttonLogin.isEnabled = true
            buttonLogin.backgroundColor = kColorButtonActive
        } else {
            buttonLogin.isEnabled = false
            buttonLogin.backgroundColor = kColorInactive
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()
    }
    
    @IBAction func eyeAction(sender: AnyObject) {
        if(iconClick == true) {
            buttonPassword.setImage(UIImage(named: "EyeOpen"), for: .selected)
            passwordField.isSecureTextEntry = true
            buttonPassword.isSelected = !iconClick
        } else {
            buttonPassword.setImage(UIImage(named: "EyeClose"), for: .normal)
            passwordField.isSecureTextEntry = false
            buttonPassword.isSelected = !iconClick
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
    
    @IBAction func ForgotButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: SeguesIdentifiers.openRecoveryPassword.rawValue, sender: self)
    }
}
