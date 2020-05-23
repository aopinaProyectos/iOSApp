//
//  LoginViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/3/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import UIKit
import CountryPickerView
import Lottie
import TLCustomMask
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var sectionAnimationView: UIView!
    @IBOutlet weak var sectionphoneView: UIView!
    @IBOutlet weak var virtualAnimationView: UIView!
    @IBOutlet weak var phoneAreaCode: CountryPickerView!
    @IBOutlet weak var cpvMain: CountryPickerView!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    @IBOutlet weak var bottomView: NSLayoutConstraint!
    @IBOutlet weak var buttonNext: UIButton!
    
    let services = ServiceManager()
    let disposeBag: DisposeBag = DisposeBag()
    
    var flagKeyboard: Bool = true
    var flagUseKeyBoard: Bool = false
    
    let lottieLogo = LOTAnimationView(name: "Login")
    var handlerSplash: () -> () = {}
    var isFinishedFlow : Bool = false
    
    var phoneNumber: String = ""
    
    var customMask = TLCustomMask()
    
    //Funcion principal del View
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTap()
        createButton()
        phoneNumberField.delegate = self
        customMask.formattingPattern = "$$ $$$$ $$$$$$$$$$$$$"
        cpvMain.tag = 1
        cpvMain.dataSource = self
        cpvMain.setCountryByCode("MX")
        cpvMain.countryDetailsLabel.font = UIFont(name: "Arial", size: 14)
        cpvMain.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        loadSplash()
        setupView()
    }
    
    func createButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 4, y: 60, width: 80, height: 20)
        button.setTitle("< Tutorial", for: .normal)
        button.setTitleColor(kColorButtonActive, for: .normal)
        button.addTarget(self, action: #selector(backTuto), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    
    //Funcion para la carga de la animación
    func loadSplash() {
        let animationFrame = CGRect(
            x: 25,
            y: 20,
            width: virtualAnimationView.frame.size.width,
            height: virtualAnimationView.frame.size.height
        )
        lottieLogo.frame = animationFrame
        lottieLogo.clipsToBounds = true
        lottieLogo.contentMode = UIView.ContentMode.scaleAspectFill
        lottieLogo.loopAnimation = true
        virtualAnimationView.addSubview(lottieLogo)
        
        lottieLogo.play { (finished) in
            print ("ImageLogin Starting")
        }
    }
    
    //Se agrega esta funcion para los observadores del teclado
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Setup de TextField y Button
    func setupView() {
        phoneNumberField.borderWidth = 0
        phoneNumberField.borderStyle = .none
        phoneNumberField.attributedPlaceholder = NSAttributedString(string: "55 4444 3333", attributes: [NSAttributedString.Key.foregroundColor: kColorPlaceHolder])
        phoneNumberField.textColor = kColorText
        buttonNext.isEnabled = false
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
    
//    Ajuste del view del Login
    func adjustView(){
        lottieLogo.stop()
        virtualAnimationView.isHidden = true
        phoneNumberField.text = ""
        buttonNext.isHidden = false
        UIView.animate(withDuration: 1.8, animations: { () -> Void in
            self.bottomView.constant = 600
        })
    }
    
    //55 4306 1607
    func validateNumber(numb: String){
        if numb.count > 11 {
            buttonNext.isEnabled = true
            buttonNext.backgroundColor = #colorLiteral(red: 0.3111690581, green: 0.5590575933, blue: 0.8019174337, alpha: 1)
        } else {
            buttonNext.isEnabled = false
            buttonNext.backgroundColor = #colorLiteral(red: 0.8765067458, green: 0.876527369, blue: 0.8765162826, alpha: 1)
        }
        
    }
    
    func sendCode(phone: String) {
        APIVirtualLines.checkLogin(number: phone).debug("APIVirtualLines.SendCode").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            print (dataResponse)
            //self.performSegue(withIdentifier: SeguesIdentifiers.openCodeVerification.rawValue, sender: self)
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func checkStatusUser(phone: String) {
        APIVirtualLines.checkStatus(number: phone).debug("APIVirtualLines.CheckStatus").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            switch dataResponse.status {
            case 1:
                self.performSegue(withIdentifier: SeguesIdentifiers.openLoginPassword.rawValue, sender: self)
            case 0:
                print("Go to Alert")
            case -1:
                self.performSegue(withIdentifier: SeguesIdentifiers.openRegisterName.rawValue, sender: self)
            case -2:
                self.sendCode(phone: self.phoneNumber)
                self.performSegue(withIdentifier: SeguesIdentifiers.openCodeVerification.rawValue, sender: self)
            case -3:
                self.sendCode(phone: self.phoneNumber)
                self.performSegue(withIdentifier: SeguesIdentifiers.openCodeVerification.rawValue, sender: self)
            default:
                print("Default")
            }
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    //Funciones para las acciones de los controles
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        validateNumber(numb: phoneNumberField.text!)
    }
    
    @IBAction func textFieldDidSelect(_ sender: Any) {
        adjustView()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        var count = cpvMain.selectedCountry.phoneCode
        let pho = self.phoneNumberField.text!
        let correccion = pho.replacingOccurrences(of: " ", with: "")
        count.removeFirst()
        self.phoneNumber = count + "1" + correccion
        AppInfo().phone = self.phoneNumber
        checkStatusUser(phone: self.phoneNumber)//Aqui descomentar aopina
        //sendCode(phone: self.phoneNumber)
        //self.performSegue(withIdentifier: SeguesIdentifiers.openCodeVerification.rawValue, sender: self) //Aqui se descomenta para evitar el servicio
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
    
    @objc func backTuto() {
        UIStoryboard.loadTutorial()
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberField {
            phoneNumberField.text = customMask.formatStringWithRange(range: range, string: string)
        }
        validateNumber(numb: phoneNumberField.text!)
        return false
    }
}

//Extension para el tunning del CountryPickerView
extension LoginViewController: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        if countryPickerView.tag == cpvMain.tag {
            var countries = [Country]()
            ["MX", "US", "FR"].forEach { code in
                if let country = countryPickerView.getCountryByCode(code){
                    countries.append(country)
                }
            }
            return countries
        }
        return []
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        if countryPickerView.tag == cpvMain.tag {
            return NSLocalizedString("PREFERENCES", comment: "CountryPickerView")
        }
        return nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        if countryPickerView.tag == cpvMain.tag {
            return false
        }
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return NSLocalizedString("TITLESECTIONS", comment: "CountryPickerView")
    }
    
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        if countryPickerView.tag == cpvMain.tag {
            return true
        }
        return false
    }
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        let closeButton = UIBarButtonItem(title: NSLocalizedString("BUTTONCANCEL", comment: "CountryPickerView"), style: .plain, target: self, action:#selector(LoginViewController.close) )
        return closeButton
    }
    
    @objc func close(){
        self.close()
    }
    
}
