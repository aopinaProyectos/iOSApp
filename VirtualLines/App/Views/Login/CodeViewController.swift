//
//  CodeViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/11/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import KKPinCodeTextField
import RxSwift

class CodeViewController: UIViewController {
    
    
    @IBOutlet weak var code: KKPinCodeTextField!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var buttonResend: UIButton!
    
    let services = ServiceManager()
    let disposeBag: DisposeBag = DisposeBag()
    
    var phone: String = ""
    var codeVerif: String = ""
    var seconds = 35
    var timer = Timer()
    
    
    override func viewDidLoad() {
        phone = AppInfo().phone
        phoneNumber.text = phone
        code.becomeFirstResponder()
        hideKeyBoardWhenTap()
        runTimer()
        applyLocalization()
    }
    
    func applyLocalization() {
        changeLabel.textColor = kColorActive
        buttonResend.isEnabled = false
        instructionsLabel.text = Message.INSTRUCTIONS.localized
        resendLabel.text = Message.BUTTONRESEND.localized
        changeLabel.text = Message.BUTTONCHANGE.localized
    }
    
    func verificationCode() {
        APIVirtualLines.verificationCode(code: codeVerif, number: phone).debug("APIVirtualLines.VerificationCode").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.performSegue(withIdentifier: SeguesIdentifiers.openRegisterName.rawValue, sender: self)
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.verificationCode()
            default:
                break
            }
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func sendCode(phone: String) {
        APIVirtualLines.sendCodeAgain(number: phone).debug("APIVirtualLines.SendCode").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            print (dataResponse)
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func runTimer() {
        seconds = 35
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CodeViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if String(seconds).count == 1 {
            timerLabel.text = "00:0" + String(seconds) + " s"
        }else {
            timerLabel.text = "00:" + String(seconds) + " s"
        }
        if seconds == 0 {
            timer.invalidate()
            timerLabel.textColor = kColorActive
            resendLabel.textColor = kColorActive
            buttonResend.isEnabled = true
        }
        
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        if code.text?.count == 4 {
            codeVerif = code.text!
            verificationCode() //Esto se debe de comentarse para saltar el servicio aopina
        }
    }
    
    @IBAction func backView() {
        UIStoryboard.loadLogin()
    }
    
    @IBAction func sendCodeAgain() {
        sendCode(phone: self.phone)
        resendLabel.textColor = kColorInactive
        timerLabel.textColor = kColorInactive
        buttonResend.isEnabled = false
        runTimer()
        
    }
}
