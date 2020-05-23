//
//  RegisterHostNameViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/19/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class RegisterHostNameViewController: UIViewController {
    
    @IBOutlet weak var nameStore: UITextField!
    @IBOutlet weak var emailStore: UITextField!
    @IBOutlet weak var category: PickerVirtualLines!
    @IBOutlet weak var nameStoreLine: UILabel!
    @IBOutlet weak var emailStoreLine: UILabel!
    @IBOutlet weak var categoryLine: UILabel!
    @IBOutlet weak var nextbutton: UIButton!
    @IBOutlet weak var bottomButton: NSLayoutConstraint!
    @IBOutlet weak var iconStore: UIImageView!
    @IBOutlet weak var iconMail: UIImageView!
    
    var categorySelected: Category = Category()
    var storeProfile: StoreProfile = StoreProfile()
    var categoryFirst: Category?
    var name = ""
    var email = ""
    var categ = ""
    var flagKeyboard: Bool = true
    var flagUseKeyBoard: Bool = false
    var cat: [Category]? {
        didSet {
            guard let categ = self.cat,
                let cat = categ.first
                else { return }
            
            self.category.items = categ.map { $0.name }
            self.category.selectedItem = Message.PCKCATEGORYFIRST.localized
        }
    }
    
    var comeFromMenu: Bool = false
    
    let disposeBag: DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTap()
        applyLocalization()
        setupView()
        getCategories()
    }
    
    //Se agrega esta funcion para los observadores del teclado
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),name: UIResponder.keyboardWillHideNotification, object: nil)
        if comeFromMenu {
            self.tabBarController?.tabBar.isHidden = true
            setTitleChild("Se un Host Paso 1 de 3")
        }else {
            createButton()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openMapHost.rawValue {
            let viewController = segue.destination as! MapHostSignUpViewController
            viewController.storeProfile = storeProfile
            if comeFromMenu {
                viewController.comeFromMenu = true
            }
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            if AppInfo().isUserHost {
                UIStoryboard.loadMenuHost()
            }else {
                UIStoryboard.loadMenu()
            }
        }
    }
    
    func createButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 4, y: 60, width: 100, height: 10)
        button.setTitle("< Ir al Menú", for: .normal)
        button.setTitleColor(kColorButtonActive, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func validateTextField() -> Bool {
        if isValidEmailAddress(email: emailStore.text!) == false {
            emailStoreLine.backgroundColor = UIColor.red
            return false
        }
        if nameStore.text == "" {
            nameStoreLine.backgroundColor = UIColor.red
            return false
        }
        if category.selectedItem == Message.PCKCATEGORYFIRST.localized {
            categoryLine.backgroundColor = UIColor.red
            return false
        }
        return true
    }
    
    func applyLocalization() {
        nameStore.placeholder = Message.PHDNAMESTORE.localized
        emailStore.placeholder = Message.PHDEMAIL.localized
    }
    
    func setupView() {
        self.category.delegate = self
        emailStore.attributedPlaceholder = NSAttributedString(string: Message.PHDEMAIL.localized,
                                                         attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
        nameStore.attributedPlaceholder = NSAttributedString(string: Message.PHDNAMESTORE.localized,
                                                        attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
        nameStore.autocapitalizationType = .words
        emailStore.textColor = kColorActive
        nameStore.textColor = kColorActive
        category.tintColor = kColorInactive
        
        nextbutton.backgroundColor = kColorButtonActive
        nextbutton.isEnabled = true
        iconStore.image = iconStore.image?.tinted(with: kColorInactive)
        iconMail.image = iconMail.image?.tinted(with: kColorInactive)
        
        emailStore.borderWidth = 0
        emailStore.borderStyle = .none
        
        nameStore.borderWidth = 0
        nameStore.borderStyle = .none
        
        category.pickerTitle = Message.PCKCATEGORY.localized
        category.name = "Categ"
        
        categoryFirst?.name = Message.PCKCATEGORYFIRST.localized
        category.selectedItem = categoryFirst?.name
        
        nameStore.becomeFirstResponder()
        
    }
    
    func getCategories(){
        APIVirtualLines.getCategories().debug("GetCategories").subscribe(onNext: {(categories) in
            print("onNext")
            print(categories)
            self.cat = categories.categories
            //self.cat = categories
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getCategories()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    
    func getData() {
        storeProfile.store.name = nameStore.text!
        storeProfile.store.email = emailStore.text!
        storeProfile.store.storeCategoryId = categorySelected.id
        
        name = nameStore.text!
        email = emailStore.text!
        categ = category.selectedItem!
    }
    
    func validateButton() {
        getData()
        /*if name != "" && isValidEmailAddress(email: email) && categ != Message.PCKCATEGORYFIRST.localized {
            nextbutton.isEnabled = true
            nextbutton.backgroundColor = kColorButtonActive
        } else {
            nextbutton.isEnabled = false
            nextbutton.backgroundColor = kColorButtonInactive
        }*/
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
        UIStoryboard.loadMenu()
    }
    
    @IBAction func didtextediting() {
        emailStoreLine.backgroundColor = kColorInactive
        categoryLine.backgroundColor = kColorInactive
        nameStoreLine.backgroundColor = kColorInactive
        validateButton()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if validateTextField() {
            getData()
            if comeFromMenu {
                let controller = storyboard!.instantiateViewController(withIdentifier: "MapHostSU")
                let viewController = controller as! MapHostSignUpViewController
                viewController.storeProfile = storeProfile
                self.navigationController!.pushViewController(controller, animated: true)
            }else {
                self.performSegue(withIdentifier: SeguesIdentifiers.openMapHost.rawValue, sender: self)
            }
        }
    }
    
    
}

extension RegisterHostNameViewController : PickerVirtualLinesDelegate {
    func didSelect(_ sender: PickerVirtualLines, index: Int) {
        validateButton()
        if sender == self.category {
            self.categorySelected = (cat?[index])!
        }
    }
}
