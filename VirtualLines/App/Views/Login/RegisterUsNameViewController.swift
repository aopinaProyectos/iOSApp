//
//  RegisterUsNameViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/11/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

class RegisterUsNameViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var emailLine: UILabel!
    @IBOutlet weak var nameLine: UILabel!
    @IBOutlet weak var passwordLine: UILabel!
    
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    
    var flagKeyboard: Bool = true
    var flagUseKeyBoard: Bool = false
    
    var emailText: String = ""
    var nameText: String = ""
    var passwordText: String = ""
    
    var iconClick = true
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.hideKeyBoardWhenTap()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
        createButton()
    }
    
    func setupView(){
        buttonNext.isEnabled = true
        buttonNext.backgroundColor = kColorButtonActive
        email.borderWidth = 0
        email.borderStyle = .none
        name.borderWidth = 0
        name.borderStyle = .none
        password.borderWidth = 0
        password.borderStyle = .none
        password.isSecureTextEntry = true
        email.attributedPlaceholder = NSAttributedString(string: Message.PHDEMAIL.localized,
                                                   attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
        name.attributedPlaceholder = NSAttributedString(string: Message.PHDNAME.localized,
                                                         attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
        password.attributedPlaceholder = NSAttributedString(string: Message.PHDNEWPWD.localized,
                                                         attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
        email.textColor = kColorActive
        name.textColor = kColorActive
        password.textColor = kColorActive
        email.becomeFirstResponder()
    }
    
    func createButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 4, y: 60, width: 80, height: 10)
        button.setTitle("< Regresar", for: .normal)
        button.setTitleColor(kColorButtonActive, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(button)
        
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
    
    func showAlert() {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "TutorialSlideHostViewController") as! TutorialSlideHostViewController
        self.view.addSubview(customAlert.view)
        
        customAlert.handlerHostSignUp = {
            customAlert.removeFromParent()
            customAlert.view.removeFromSuperview()
            self.performSegue(withIdentifier: SeguesIdentifiers.openDataNameHost.rawValue, sender: self)
        }
        
        customAlert.handlerGoToMenu = {
            customAlert.removeFromParent()
            customAlert.view.removeFromSuperview()
            AppInfo().isUserHost = false
            AppInfo().userName = AppInfo().phone
            AppInfo().password = self.passwordText
            self.goToMenu()
        }
        
        customAlert.handlerCloseView = {
            customAlert.removeFromParent()
            customAlert.view.removeFromSuperview()
        }
    }
    
    func goToMenu() {
        UIStoryboard.loadMenu()
    }
    
    func getData() {
        emailText = email.text!
        nameText = name.text!
        passwordText = stringToCrypto(text: password.text!)
    }
    
    func validateTextField() -> Bool {
        if isValidEmailAddress(email: email.text!) == false {
            emailLine.backgroundColor = UIColor.red
            return false
        }
        
        if name.text == "" {
            nameLine.backgroundColor = UIColor.red
            return false
        }
        
        if password.text == "" {
            passwordLine.backgroundColor = UIColor.red
            return false
        }
        return true
    }
    
    //Method to eye Action
    @IBAction func eyeAction(sender: AnyObject) {
        if(iconClick == true) {
            eyeImage.image = UIImage(named: "EyeOpen")
            password.isSecureTextEntry = false
        } else {
            eyeImage.image = UIImage(named: "EyeClose")
            password.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    
    //Method to validate the changes in TextField
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        emailLine.backgroundColor = #colorLiteral(red: 0.8765067458, green: 0.876527369, blue: 0.8765162826, alpha: 1)
        nameLine.backgroundColor = #colorLiteral(red: 0.8765067458, green: 0.876527369, blue: 0.8765162826, alpha: 1)
        passwordLine.backgroundColor = #colorLiteral(red: 0.8765067458, green: 0.876527369, blue: 0.8765162826, alpha: 1)
    }
    
    @IBAction func textFieldDidSelectEmail(_ sender: Any) {
        //email.text = ""
        
    }
    
    @IBAction func textFieldDidSelectName(_ sender: Any) {
        //name.text = ""
        
    }
    @IBAction func textFieldDidSelectPass(_ sender: Any) {
        //password.isSecureTextEntry = true
        //password.text = ""
        
    }
    
    @IBAction func buttonNext(_ sender: Any) {
        if validateTextField() {
            self.getData()
            self.registerUser()
            //self.showAlert() //Esto se debe de comentar para saltar los servicios aopina
        }
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
    
    @objc func back() {
        UIStoryboard.loadLogin()
    }
    
    
    
    
}

//Extension para el tunning del teclado levantado
extension RegisterUsNameViewController {
    
    func registerUser() {
        let parameters = createBody()
        let body = ["profile":parameters]
        APIVirtualLines.signupUser(body: body).debug("APIVirtualLines.VerificationCode").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            print (dataResponse)
            self.showAlert()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.registerUser()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["firstName"] = nameText
        bodyCollection["email"] = emailText
        bodyCollection["phone"] = AppInfo().phone
        bodyCollection["password"] = passwordText
        bodyCollection["customerType"] = 10
        bodyCollection["birthdate"] = ""
        bodyCollection["language"] = "es"
        bodyCollection["gender"] = nil
        bodyCollection["picture"] = nil
        return bodyCollection
    }
}
