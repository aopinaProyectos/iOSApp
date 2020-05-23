//
//  ProfileViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/7/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SkeletonView
import UICircularProgressRing

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CollapsibleTableViewHeaderDelegate, UICircularProgressRingDelegate, cellButtonProfileDelegate, cellTextFieldProfileDelegate, cellGenderProfileDelegate, cellBirthProfileDelegate, addressPopCell2Delegate, cellLanguageProfileDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var porcentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressBar: UICircularProgressRing!
    
    var percent = 0
    var countAddress = 0
    var gender = ""
    var birth = ""
    var firstName = ""
    var email = ""
    var phoneNumber = ""
    
    
    var flagCollapsedData = false
    var flagCollapsedAddress = true
    var flagCollapsedPassword = true
    var flagBirth = false
    var flagGender = false
    var flagError = false
    var flagPass = false
    var flagTable = false
    
    var oldPassword: String = ""
    var currentPassword: String = ""
    
    var imagePicker = UIImagePickerController()
    var imageProfile = UIImage()
    var password: Password = Password()
    var profileUser: ProfileUser = ProfileUser()
    var serviceProfile: UpdateProfile = UpdateProfile()
    var userLocations: [Locations] = [Locations]()
    var arrayaddress: [AddressUser] = [AddressUser]()
    
    let phone = AppInfo().phone
    let disposeBag: DisposeBag = DisposeBag()
    var datePicker = UIDatePicker()
    var toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupSkeletonView() //Descomentar para el tema de servicios
        self.progressBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView!.register(UINib(nibName: kDataProfileViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataProfileViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kButtonProfileViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kButtonProfileViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kGenderProfileViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kGenderProfileViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kBirthProfileViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kBirthProfileViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kAddressPopCell2ReuseIdentifier, bundle: nil), forCellReuseIdentifier: kAddressPopCell2ReuseIdentifier)
        self.tableView!.register(UINib(nibName: kLanguageProfileViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kLanguageProfileViewCellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfile()
        //ersetupView()
    }
    
    func setupSkeletonView() {
        profileImage.isHidden = true
        nameLabel.isHidden = true
        porcentLabel.isHidden = true
        tableView.isSkeletonable = true
        progressBar.isHidden = true
        flagCollapsedData = true
        flagCollapsedAddress = true
        flagCollapsedPassword = true
    }
    
    func setupView() {
        self.progressBar.shouldShowValueText = false
        self.progressBar.backgroundColor = UIColor.clear
        self.progressBar.borderColor = UIColor.white
        self.progressBar.maxValue = 100
        self.progressBar.minValue = 0
        self.progressBar.startProgress(to: 0, duration: 0.0) {
            self.progressBar.startProgress(to: CGFloat(self.percent), duration: 5)
        }
    }
    
    func checkPercent() {
        var result = 0
        if self.profileUser.firstName != "" {
            result = result + 1
        }
        if self.profileUser.email != "" {
            result = result + 1
        }
        if self.profileUser.phone != "" {
            result = result + 1
        }
        if self.profileUser.birthdate != "" {
            result = result + 1
        }
        if self.profileUser.gender != "" {
            result = result + 1
        }
        percent = (result * 100) / 5
    }
    
    func getUserProfile() {
        APIVirtualLines.getUserProfile(number: phone).debug("APIVirtualLines.GetUserProfile").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.profileUser = dataResponse.profileUser!
            self.firstName = self.profileUser.firstName
            self.email = self.profileUser.email
            self.phoneNumber = self.profileUser.phone
            self.birth = self.profileUser.birthdate
            self.gender = self.profileUser.gender
            self.nameLabel.text = self.firstName
            self.checkPercent()
            self.loadAddress()
            self.tableView.reloadData()
            self.setupView()
        }, onError: {(error) in
            switch error {
            case CatalogError.ErrorGeneral(let response):
                self.showAlertError(id: 2, text: response.message)
            case CatalogError.TokenRenew:
                self.getUserProfile()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func changePassword() {
        self.password.passwords.newPassword = stringToCrypto(text: self.currentPassword)
        self.password.passwords.currentPassword = stringToCrypto(text: self.oldPassword)
        APIVirtualLines.changePassword(number: phone, body: self.password).debug("APIVirtualLines.ChangePassword").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            AppInfo().password = self.stringToCrypto(text: self.currentPassword)
            self.showAlertError(id: 3, text: dataResponse.message)
            self.flagPass = true
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.changePassword()
            case CatalogError.ErrorGeneral(let response):
                self.showAlertError(id: 2, text: response.message)
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func updateProfile() {
        updateData()
        APIVirtualLines.updateProfile(number: phone, body: serviceProfile, image: self.imageProfile).debug("APIVirtualLines.UpdateProfile").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.showAlertError(id: 4, text: dataResponse.message)
            self.flagPass = true
            self.flagTable = true
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.updateProfile()
            case CatalogError.ErrorGeneral(let response):
                self.showAlertError(id: 2, text: response.message)
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func loadAddress() {
        let placeData = UserDefaults.standard.data(forKey: "address")
        let placeArray = try! JSONDecoder().decode([AddressUser].self, from: placeData!)
        if placeArray.count != 0 {
            countAddress = placeArray.count
            arrayaddress = placeArray
        }else {
            countAddress = 0
        }
    }
    
    func showAlertError(id: Int, text: String) {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "ErrorNetworkingAlertViewController") as! ErrorNetworkingAlertViewController
        customAlert.id = id
        customAlert.text = text
        self.view.addSubview(customAlert.view)
        
        customAlert.handlerCloseView = {
            if self.flagError {
                customAlert.view.removeFromSuperview()
                self.tabBarController?.selectedIndex = 2
            }else {
                if self.flagPass {
                    self.tableView!.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)
                    self.flagPass = false
                    customAlert.view.removeFromSuperview()
                }
                if self.flagTable {
                    self.getUserProfile()
                    self.flagTable = false
                }
            }
        }
        customAlert.handlerRestart = {
            //self.restartApplication()
            exit(-1)
        }
        
    }
    
    /*func restartApplication () {
        let viewController = SplashViewController()
        let navCtrl = UINavigationController(rootViewController: viewController)
        
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
            else {
                return
        }
        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
    }*/
    
    func getData(sender: UITextField) {
        switch sender.tag {
        case 0:
            self.firstName = sender.text!
        case 1:
            self.email = sender.text!
        case 2:
            self.phoneNumber = sender.text!
        case 6:
            self.oldPassword = sender.text!
        case 7:
            self.currentPassword = sender.text!
        default:
            break
        }
    }
    
    func pressSave(sender: UIButton) {
        switch sender.tag {
        case 2:
            changePassword()
        case 5:
            if validateData() {
                updateProfile()
            }
        default:
            break
        }
    }
    
    func pressMale(sender: UIButton) {
        self.gender = "M"
        self.flagGender = true
    }
    
    func pressFemale(sender: UIButton) {
        self.gender = "F"
        self.flagGender = true
    }
    
    func datePicker(sender: UIButton) {
        showDatePicker()
    }
    
    func showDatePicker(){
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 200, width: self.view.frame.size.width, height: 200))
        datePicker.datePickerMode = .date
        if flagBirth {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from: self.birth)
            datePicker.date = date!
        }else {
             datePicker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        }
        datePicker.backgroundColor = UIColor.white
        toolbar = UIToolbar(frame:CGRect(x: 0, y: self.view.frame.size.height - 250, width: self.view.frame.size.width, height: 50))
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        self.view.addSubview(toolbar)
        self.tabBarController?.tabBar.isHidden = true
        self.view.addSubview(datePicker)
    }
    
    func removeAddress(sender: UIButton) {
        print ("RemoveElement")
    }
    
    func getAlert() {
        showAlertError(id: 5, text: "")
    }
    
    @IBAction func imageTapped() {
        let optionMenu = UIAlertController(title: nil, message: Message.REQUESTIMAGE.localized, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: Message.PHOTOLIBRARY.localized, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        optionMenu.addAction(libraryAction)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let takePhotoAction = UIAlertAction(title: Message.TAKEPHOTO.localized, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            optionMenu.addAction(takePhotoAction)
        }
        let cancelAction = UIAlertAction(title: Message.CANCEL.localized, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.birth = formatter.string(from: datePicker.date)
        self.flagBirth = true
        let indexPath = IndexPath(item: 4, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .top)
        self.tabBarController?.tabBar.isHidden = false
        self.view.endEditing(true)
        datePicker.removeFromSuperview()
        toolbar.removeFromSuperview()
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.profileImage.image = selectedImage
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
            self.profileImage.clipsToBounds = true
            //images.append(selectedImage!)
            //isImages = true
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.profileImage.image = selectedImage
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
            self.profileImage.clipsToBounds = true
            //images.append(selectedImage!)
            //isImages = true
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateData() {
        serviceProfile.profile.firstName = self.firstName
        serviceProfile.profile.email = self.email
        serviceProfile.profile.phone = self.phoneNumber
        serviceProfile.profile.password = self.profileUser.password
        serviceProfile.profile.customerType = 10
        serviceProfile.profile.birthdate = self.birth
        serviceProfile.profile.language = "es"
        serviceProfile.profile.gender = self.gender
        self.imageProfile = self.profileImage.image!
    }
    
    func validateData() -> Bool {
        if self.firstName == "" {
            showAlertError(id: 2, text: "Tu nombre no puede quedar vacio")
            return false
        }
        if self.email == "" {
            showAlertError(id: 2, text: "Tu email no puede quedar vacio")
            return false
        }
        if self.phoneNumber == "" {
            showAlertError(id: 2, text: "Tu telefono no puede quedar vacio")
            return false
        }
        return true
    }
    
    
//    Mark TableView and CollapsibleTable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return flagCollapsedData ? 0 : 5
        case 1:
            return flagCollapsedAddress ? 0 : countAddress
        case 2:
            return flagCollapsedPassword ? 0 : 3
        default:
            return 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataProfileViewCell") as! dataProfileViewCell
        let cellButton = tableView.dequeueReusableCell(withIdentifier: "buttonProfileViewCell") as! buttonProfileViewCell
        let cellGender = tableView.dequeueReusableCell(withIdentifier: "genderProfileViewCell") as! genderProfileViewCell
        let cellBirth = tableView.dequeueReusableCell(withIdentifier: "birthProfileViewCell") as! birthProfileViewCell
        let cellLanguage = tableView.dequeueReusableCell(withIdentifier: "languageProfileViewCell") as! languageProfileViewCell
        let cellAddress = tableView.dequeueReusableCell(withIdentifier: "addressPopCell2") as! addressPopCell2
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cellLanguage.cellDelegate = self
                cellLanguage.setupView()
                return cellLanguage
            case 1:
                cellDefault.cellDelegate = self
                cellDefault.setupView(section: 0, row: indexPath.row, text: self.profileUser.email)
                return cellDefault
            /*case 2:
                cellDefault.cellDelegate = self
                cellDefault.setupView(section: 0, row: indexPath.row, text: self.profileUser.phone)*/
            case 2:
                if flagGender {
                    cellGender.cellDelegate = self
                    cellGender.setupView(text: self.gender)
                    return cellGender
                }else {
                    cellGender.cellDelegate = self
                    cellGender.setupView(text: self.profileUser.gender)
                    return cellGender
                }
            case 3:
                if flagBirth {
                    cellBirth.cellDelegate = self
                    cellBirth.setupView(text: self.birth)
                    return cellBirth
                }else {
                    cellBirth.cellDelegate = self
                    cellBirth.setupView(text: self.profileUser.birthdate)
                    return cellBirth
                }
            case 4:
                cellButton.buttonSave.tag = indexPath.row
                cellButton.cellDelegate = self
                cellButton.setupView()
                return cellButton
            default:
                break
            }
        }else if indexPath.section == 1 {
            cellAddress.cellDelegate = self
            cellAddress.setupView(myAddress: arrayaddress[indexPath.row])
            return cellAddress
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0...1:
                cellDefault.cellDelegate = self
                cellDefault.setupView(section: indexPath.section, row: indexPath.row, text: "")
            case 2:
                cellButton.buttonSave.tag = indexPath.row
                cellButton.cellDelegate = self
                cellButton.setupView()
                return cellButton
            default:
                break
            }
        }
        return cellLanguage
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            header.titleLabel.text = Message.TITLEPROFILEDATA.localized
            header.arrowLabel.text = ">"
            header.setupCell()
            header.setCollapsed(flagCollapsedData)
            header.section = section
            header.delegate = self
            return header
        case 1:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            header.titleLabel.text = Message.TITLEADDRESS.localized
            header.arrowLabel.text = ">"
            header.setupCell()
            header.setCollapsed(flagCollapsedAddress)
            header.section = section
            header.delegate = self
            return header
        case 2:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            header.titleLabel.text = Message.TITLECHANGEPASSWORD.localized
            header.arrowLabel.text = ">"
            header.setupCell()
            header.setCollapsed(flagCollapsedPassword)
            header.section = section
            header.delegate = self
            return header
            
        default:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            return header
            
        }
    }
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        if section == 0 {
            flagCollapsedData = !flagCollapsedData
            header.setCollapsed(flagCollapsedData)
        }else if section == 1 {
            flagCollapsedAddress = !flagCollapsedAddress
            header.setCollapsed(flagCollapsedAddress)
        }else if section == 2 {
            flagCollapsedPassword = !flagCollapsedPassword
            header.setCollapsed(flagCollapsedPassword)
        }
        tableView!.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    func didFinishProgress(for ring: UICircularProgressRing) {
        print ("finish")
    }
    
    func didPauseProgress(for ring: UICircularProgressRing) {
        print ("finish")
    }
    
    func didContinueProgress(for ring: UICircularProgressRing) {
        print ("finish")
    }
    
    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: CGFloat) {
        let percents = String(format: "%.0f", newValue)
        self.porcentLabel.text = Message.PERCENTPROFILE.localized + percents + "%"
    }
    
    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {
        print ("finish")
    }
}
