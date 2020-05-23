//
//  ProfileHostViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/20/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import AlamofireImage
import RxSwift

class ProfileHostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CollapsibleTableViewHeaderDelegate, cellDataFieldDelegate, cellAboutDelegate {
    
    @IBOutlet weak var viewSlideImages: ImageSlideshow!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var store: StoreDetail = StoreDetail()
    var arrayDays: [DayData] = [DayData]()
    
    var id: Int = 0
    var index: Int = 0
    var flagError: Bool = false
    var flagEmpty: Bool = true
    var flagCollapsedPro = false
    var flagCollapsedSche = false
    var flagCollapsedAbout = false
    var webSite: String = ""
    var phoneStore: String = ""
    var descript: String = ""
    
    var images = [InputSource]()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView!.register(UINib(nibName: kTableViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kTableViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kAboutViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kAboutViewCellReuseIdentifier)
        self.tableView!.register(UINib(nibName: kScheduleCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kScheduleCellReuseIdentifier)
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getInformationStore()
    }
    
    func setupView() {
        if store.images == nil {
            let image = UIImage(named: "Restaurants")
            images.append(ImageSource(image: image!))
        }else {
            for image in store.images {
                let alamoSource = AlamofireSource(urlString: image.url, placeholder: UIImage(named: "Restaurants"))!
                images.append(alamoSource)
            }
        }
        configureSlideView()
        storeNameLabel.text = "     " + store.name
        tableView.reloadData()
    }
    
    func getData() {
        webSite = store.webSite
        phoneStore = store.phone
        descript = store.storeDescription
        defaultSchedule()
    }
    
    func defaultSchedule() {
        for i in 0...6 {
            switch i {
            case 0:
                let days = DayData()
                days.day = i
                days.time = store.schedules.monday
                days.active = true
                arrayDays.insert(days, at: i)
            case 1:
                let days = DayData()
                days.day = i
                days.time = store.schedules.tuesday
                days.active = true
                arrayDays.insert(days, at: i)
            case 2:
                let days = DayData()
                days.day = i
                days.time = store.schedules.wednesday
                days.active = true
                arrayDays.insert(days, at: i)
            case 3:
                let days = DayData()
                days.day = i
                days.time = store.schedules.thursday
                days.active = true
                arrayDays.insert(days, at: i)
            case 4:
                let days = DayData()
                days.day = i
                days.time = store.schedules.friday
                days.active = true
                arrayDays.insert(days, at: i)
            case 5:
                let days = DayData()
                days.day = i
                days.time = store.schedules.saturday
                days.active = true
                arrayDays.insert(days, at: i)
            case 6:
                let days = DayData()
                days.day = i
                days.time = store.schedules.sunday
                days.active = true
                arrayDays.insert(days, at: i)
            default:
                break
            }
        }
    }
    
    private func configureSlideView(){
        viewSlideImages.setImageInputs(images)
        viewSlideImages.backgroundColor = UIColor.clear
        viewSlideImages.slideshowInterval = 5.0
        viewSlideImages.pageIndicatorPosition = PageIndicatorPosition.init()
        viewSlideImages.tintColor = kColorTabBar
        viewSlideImages.pageControl.pageIndicatorTintColor = UIColor.white
        viewSlideImages.contentScaleMode = UIView.ContentMode.scaleToFill
        viewSlideImages.currentPageChanged = { page in
            self.viewSlideImages.tag = page
        }
    }
    
    func getInformationStore() {
        APIVirtualLines.getStoreInformation(id: id).debug("APIVirtualLines.getInformationStore").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.store = dataResponse.store!
            self.flagEmpty = false
            self.getData()
            self.setupView()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getInformationStore()
            case CatalogError.NoLinesFound(let response):
                self.showAlertError(id: 2, text: response.message)
                self.flagError = true
            case NetworkingError.Timeout:
                self.showAlertError(id: 0, text: "")
            case NetworkingError.NoInternet:
                self.showAlertError(id: 1, text: "")
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
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
                self.navigationController?.popViewController(animated: true)
            }else {
                customAlert.view.removeFromSuperview()
            }
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
    
    func validateField(sender: UITextField) {
        switch sender.tag {
        case 0:
            webSite = sender.text!
        case 1:
            phoneStore = sender.text!
        case 2:
            descript = sender.text!
        default:
            break
        }
    }
    
    func validateButton(_ sender: UIButton) {
        print("PressButton")
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if flagEmpty {
            return 0
        }else {
            return 3
        }
    }
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        if section == 0 {
            flagCollapsedPro = !flagCollapsedPro
            header.setCollapsed(flagCollapsedPro)
        }else if section == 2 {
            flagCollapsedSche = !flagCollapsedSche
            header.setCollapsed(flagCollapsedSche)
        }else if section == 1 {
            flagCollapsedAbout = !flagCollapsedAbout
            header.setCollapsed(flagCollapsedAbout)
        }
        //tableView!.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagEmpty {
            return 0
        }else {
            switch section {
            case 0:
                return flagCollapsedPro ? 0 : 3
            case 1:
                return flagCollapsedAbout ? 0 : 1
            case 2:
                return flagCollapsedSche ? 0 : 7
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
                cell.dataField!.tag = indexPath.row
                cell.cellDelegate = self
                cell.setupCellProfile(index: indexPath.row, text: self.webSite)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
                cell.dataField!.tag = indexPath.row
                cell.cellDelegate = self
                cell.setupCellProfile(index: indexPath.row, text: self.phoneStore)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell") as! dataFieldCell
                cell.dataField!.tag = indexPath.row
                cell.cellDelegate = self
                cell.setupCellProfile(index: indexPath.row, text: self.descript)
                return cell
            default:
                return cellDefault
            }
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let cellAbout = tableView.dequeueReusableCell(withIdentifier: "aboutViewCell") as! aboutViewCell
                cellAbout.cellDelegate = self
                cellAbout.setupCell()
                return cellAbout
            default:
                return cellDefault
            }
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0...6:
                let cellSchedule = tableView.dequeueReusableCell(withIdentifier: "scheduleViewCell") as! scheduleViewCell
                cellSchedule.dayButton?.tag = indexPath.row
                //cellSchedule.cellDelegate = self
                cellSchedule.daySwitch?.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
                cellSchedule.dayButton?.addTarget(self, action: #selector(picker(sender:)), for: .touchUpInside)
                cellSchedule.setupCell(index: indexPath.row, days: arrayDays)
                return cellSchedule
            default:
                return cellDefault
            }
        }else {
            return cellDefault
        }
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
            header.titleLabel.text = "Acerca del Negocio"
            header.arrowLabel.text = ">"
            header.setupCell()
            header.setCollapsed(flagCollapsedSche)
            header.section = section
            header.delegate = self
            return header
        case 2:
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
    
    
}
