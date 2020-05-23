//
//  ShiftDataViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/20/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Pulley

class ShiftDataViewcontroller: UIViewController {
    
    @IBOutlet weak var houseButton: UIButton!
    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var girlfriendButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var otherFieldText: UITextField!
    @IBOutlet weak var lineView: UIView!
    
    var flagOther: Bool = false
    var handlerPulley: () -> () = {}
    
    var flagKeyboard: Bool = true
    var flagUseKeyBoard: Bool = false
    
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTap()
        setupView()
    }
    
    //Se agrega esta funcion para los observadores del teclado
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupView() {
        otherFieldText.placeholder = Message.PHDOTHER.localized
        otherFieldText.isHidden = true
        otherFieldText.borderStyle = .none
        otherFieldText.borderWidth = 0
        lineView.isHidden = true
    }
    
    func openDrawer() {
        let master = parent as! GetShiftViewController
        master.pulleyOpen()
    }
    
    func closeDrawer() {
        let master = parent as! GetShiftViewController
        master.pulleyClose()
    }
    
    func partiallyDrawer() {
        let master = parent as! GetShiftViewController
        master.pulleyRevealed()
    }
    
    func sendName() {
        let master = parent as! GetShiftViewController
        master.name = self.name
    }
    
    func nextView() {
        let master = parent as! GetShiftViewController
        master.nextView()
    }
    
    func adjustButton(show:Bool, hide:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        var keybrdHeight = CGFloat(0.0)
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keybrdHeight = keyboardHeight
        }
        if show {
            openDrawer()
        }else if hide {
            partiallyDrawer()
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
    
    @IBAction func buttonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            sender.isSelected = true
            officeButton.isSelected = false
            girlfriendButton.isSelected = false
            otherButton.isSelected = false
            otherFieldText.isHidden = true
            lineView.isHidden = true
            self.name = "Casa"
            self.sendName()
            print("Casa")
        case 1:
            sender.isSelected = true
            houseButton.isSelected = false
            girlfriendButton.isSelected = false
            otherButton.isSelected = false
            otherFieldText.isHidden = true
            lineView.isHidden = true
            self.name = "Oficina"
            self.sendName()
            print("Oficina")
        case 2:
            sender.isSelected = true
            houseButton.isSelected = false
            officeButton.isSelected = false
            otherButton.isSelected = false
            otherFieldText.isHidden = true
            lineView.isHidden = true
            self.name = "Novi@"
            self.sendName()
            print("Novi@")
        case 3:
            sender.isSelected = true
            houseButton.isSelected = false
            officeButton.isSelected = false
            girlfriendButton.isSelected = false
            otherFieldText.isHidden = false
            lineView.isHidden = false
            self.name = "Otro"
            self.sendName()
        default:
            break
        }
    }
    
    @IBAction func buttonNextPressed(sender: UIButton)  {
        nextView()
    }
}


extension ShiftDataViewcontroller: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 50.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 400.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
}
