//
//  RegisterDataHostViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0
import RxSwift

class RegisterDataHostViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, cameraViewCellDelegate, cellAboutDelegate, cellDataFieldDelegate, cameraImagesViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var nextButton: UIButton?
    
    var flagCollapsedPro = false
    var flagCollapsedSche = false
    var flagAboutCell = true
    var isImages = false
    
    var storeProfile: StoreProfile = StoreProfile()
    var preferences: [Preferences] = [Preferences]()
    var arrayDays: [DayData] = [DayData]()
    var images: [UIImage] = [UIImage]()
    var pictures: [UIImage] = [UIImage]()
    var images64: [String] = [String]()
    
    var website: String = ""
    var phoneStore: String = ""
    var descrip: String = ""
    
    var storeId = 0
    
    var imagePicker = UIImagePickerController()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTap()
        defaultSchedule()
        fillPreferences()
        tableView!.estimatedRowHeight = 44.0
        tableView!.rowHeight = UITableView.automaticDimension
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.tableView!.register(UINib(nibName: kTableViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kTableViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kCameraCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kCameraCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kAboutViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kAboutViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kScheduleCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kScheduleCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kCameraImagesCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kCameraImagesCellReuseIdentifier)
        configButton()
        setTitleChild("Se un Host Paso 2 de 3")
    }
    
    func configButton() {
        nextButton?.isEnabled = true
        nextButton?.backgroundColor = kColorButtonActive
    }
    
    func defaultSchedule() {
        for i in 0...6 {
            var days = DayData()
            days.day = i
            days.time = kTimeStart + " - " + kTimeEnd
            days.active = true
            arrayDays.insert(days, at: i)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            images.append(selectedImage!)
            isImages = true
            self.tableView?.reloadData()
            //let indexPath = IndexPath(item: 3, section: 0)
            //self.tableView?.reloadRows(at: [indexPath], with: .none)
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            images.append(selectedImage!)
            isImages = true
            self.tableView?.reloadData()
            //let indexPath = IndexPath(item: 3, section: 0)
            //self.tableView?.reloadRows(at: [indexPath], with: .none)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func removeButton(_ tag: Int) {
        if images.count > 0 {
            images.remove(at: tag)
            if images.count == 0 {
                isImages = false
            }
            flagAboutCell = true
            let indexPath = IndexPath(item: 3, section: 0)
            self.tableView?.reloadRows(at: [indexPath], with: .none)
        }else {
            isImages = false
            let indexPath = IndexPath(item: 3, section: 0)
            self.tableView?.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    func cameraTapped(_ tag: Int) {
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
    
}

extension RegisterDataHostViewController : UITableViewDelegate, UITableViewDataSource, CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        if section == 0 {
            flagCollapsedPro = !flagCollapsedPro
            header.setCollapsed(flagCollapsedPro)
        }else if section == 1 {
            flagCollapsedSche = !flagCollapsedSche
            header.setCollapsed(flagCollapsedSche)
        }
        tableView!.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return flagCollapsedPro ? 0 : 5
        }else {
            return flagCollapsedSche ? 0 : 7
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
                cell.dataField!.tag = indexPath.row
                cell.cellDelegate = self
                cell.setupCellProfile(index: indexPath.row, text: self.website)
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
                cell.dataField!.tag = indexPath.row
                cell.cellDelegate = self
                cell.setupCellProfile(index: indexPath.row, text: self.phoneStore)
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
                cell.dataField!.tag = indexPath.row
                cell.cellDelegate = self
                cell.setupCellProfile(index: indexPath.row, text: self.descrip)
                cell.selectionStyle = .none
                return cell
            case 3:
                if isImages {
                    let cellImage = tableView.dequeueReusableCell(withIdentifier: "cameraImagesViewCell") as! cameraImagesViewCell
                    cellImage.cellDelegate = self
                    cellImage.setupCell(flag: flagAboutCell)
                    flagAboutCell = false
                    cellImage.configureSlideView(images: images)
                    cellImage.selectionStyle = .none
                    return cellImage
                }else {
                    let cellCamera = tableView.dequeueReusableCell(withIdentifier: "cameraViewCell") as! cameraViewCell
                    cellCamera.cellDelegate = self
                    cellCamera.selectionStyle = .none
                    return cellCamera
                }
                
            case 4:
                let cellAbout = tableView.dequeueReusableCell(withIdentifier: "aboutViewCell") as! aboutViewCell
                cellAbout.cellDelegate = self
                cellAbout.setupCell()
                cellAbout.selectionStyle = .none
                return cellAbout
                
            default:
                print("Default")
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0...6:
                let cellSchedule = tableView.dequeueReusableCell(withIdentifier: "scheduleViewCell") as! scheduleViewCell
                cellSchedule.dayButton?.tag = indexPath.row
                //cellSchedule.cellDelegate = self
                cellSchedule.daySwitch?.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
                cellSchedule.dayButton?.addTarget(self, action: #selector(picker(sender:)), for: .touchUpInside)
                cellSchedule.setupCell(index: indexPath.row, days: arrayDays)
                cellSchedule.selectionStyle = .none
                return cellSchedule
            default:
                print("Default")
            }
        }
        return cellDefault
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            header.titleLabel.text = Message.TITLEPROFILE.localized
            header.arrowLabel.text = ">"
            header.setupCell()
            header.setCollapsed(flagCollapsedPro)
            header.section = section
            header.delegate = self
            return header
        case 1:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            header.titleLabel.text = Message.TITLESCHEDULE.localized
            header.arrowLabel.text = ">"
            header.setupCell()
            header.setCollapsed(flagCollapsedSche)
            header.section = section
            header.delegate = self
            return header
        default:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            print("Default")
            return header
            
        }
    }
    
    func getDataSwitch(index: Int, value:Bool) {
        switch index {
        case 0...6:
            arrayDays[index].active = value
        default:
            break
        }
    }
    
    func getDataSchedule() {
        for i in 0..<6 {
            let ndx = IndexPath(row:i, section: 1)
            let cell = tableView?.cellForRow(at: ndx) as! dataFieldCell
            switch i {
            case 0:
                self.storeProfile.store.schedules.monday = cell.dataField!.text!
            case 1:
                self.storeProfile.store.phone = cell.dataField!.text!
            case 2:
                self.storeProfile.store.storeDescription = cell.dataField!.text!
            case 3:
                self.storeProfile.store.storeDescription = cell.dataField!.text!
            case 4:
                self.storeProfile.store.storeDescription = cell.dataField!.text!
            case 5:
                self.storeProfile.store.storeDescription = cell.dataField!.text!
            case 6:
                self.storeProfile.store.storeDescription = cell.dataField!.text!
            default:
                break
            }
        }
    }
    
    func fillData() {
        self.tableView?.reloadData()
    }
    
    func showAlert(daySelected: Int) {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "scheduleHost") as! CustomPickerSchedViewController
        customAlert.days = arrayDays
        customAlert.dayPickerSelected = daySelected
        //AppInfo().dayPicker = daySelected
        AppInfo().dayPickerSelect = toDays(daySelected)
        self.view.addSubview(customAlert.view)
        
        customAlert.handlerCloseView = {
            self.arrayDays = customAlert.days
            customAlert.removeFromParent()
            customAlert.view.removeFromSuperview()
            self.fillData()
        }
    }
    
    func toDays(_ dayInt: Int) -> String {
        switch dayInt {
        case 0:
            return Message.MONDAY.localized
        case 1:
            return Message.TUESDAY.localized
        case 2:
            return Message.WEDNESDAY.localized
        case 3:
            return Message.THURSDAY.localized
        case 4:
            return Message.FRIDAY.localized
        case 5:
            return Message.SATURDAY.localized
        case 6:
            return Message.SUNDAY.localized
        default:
            return ""
        }
    }
    
    func fillPreferences() {
        for i in 1...3 {
            var pref = Preferences()
            pref.active = false
            pref.preferencesId = i
            preferences.append(pref)
        }
    }
    
    func validateField(sender: UITextField) {
        switch sender.tag {
        case 0:
            self.website = sender.text!
        case 1:
            self.phoneStore = sender.text!
        case 2:
            self.descrip = sender.text!
        default:
            break
        }
    }
    
    func validateButton(_ sender: UIButton) {
        preferences[sender.tag].active = sender.isSelected
    }
    
    func saveData() {
        saveSchedule()
        saveImages()
        self.storeProfile.store.phone = self.phoneStore
        self.storeProfile.store.webSite = self.website
        self.storeProfile.store.storeDescription = self.descrip
        self.storeProfile.store.preferences = self.preferences
    }
    
    func saveImages() {
        self.storeProfile.store.images = []
        /*if images.count != 0 {
            for imag in images {
                self.images64.append(imageTo64(imag))
            }
            self.storeProfile.store.images = self.images64
        }else {
            self.storeProfile.store.images = []
        }*/
    }
    
    func saveSchedule() {
        for day in arrayDays {
            switch day.day {
            case 0:
                self.storeProfile.store.schedules.monday = day.time
            case 1:
                self.storeProfile.store.schedules.tuesday = day.time
            case 2:
                self.storeProfile.store.schedules.wednesday = day.time
            case 3:
                self.storeProfile.store.schedules.thursday = day.time
            case 4:
                self.storeProfile.store.schedules.friday = day.time
            case 5:
                self.storeProfile.store.schedules.saturday = day.time
            case 6:
                self.storeProfile.store.schedules.sunday = day.time
            default:
                break
            }
        }
    }
    
    func getImage(){
        var image: UIImage = UIImage()
        if pictures.count != 0 {
            image = images.first!
            pictures.removeFirst()
            loadImages(storeId: storeId, pic: image)
        }else {
            UIStoryboard.loadMenuHost()
        }
    }
    
    func signUpHost() {
        pictures = images
        let phone = AppInfo().phone
        APIVirtualLines.signUpHost(body: storeProfile, number: phone).debug("APIVirtualLines.SignUpHost").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            AppInfo().isUserHost = true
            self.storeId = dataResponse.storeId
            self.getImage()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.signUpHost()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func loadImages(storeId: Int, pic: UIImage) {
        APIVirtualLines.uploadImageStore(storeId: storeId, image: pic).debug("APIVirtualLines.LoadImages").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            print (dataResponse)
            self.getImage()
            //UIStoryboard.loadMenu()
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    @objc func picker(sender: UIButton){
        let buttonTag = sender.tag
        showAlert(daySelected: buttonTag)
    }
    
    @objc func switchChanged(sender: UISwitch){
        getDataSwitch(index: sender.tag, value: sender.isOn)
        let indexPath = IndexPath(item: sender.tag, section: 1)
        self.tableView?.reloadRows(at: [indexPath], with: .none)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        saveData()
        signUpHost()
        //UIStoryboard.loadMenu()
    }
    
    
}



