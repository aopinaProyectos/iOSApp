//
//  PreviewShiftViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 7/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Pulley
import RxSwift
import ActionSheetPicker_3_0

class PreviewShiftViewController: PulleyViewController {
    
    var stores: DataStore = DataStore()
    var newShift: ShiftNewTurn = ShiftNewTurn()
    var shift: ShiftUser = ShiftUser()
    var lineSelected: InfoShift = InfoShift()
    var number = AppInfo().phone
    var flagError: Bool = false
    var dateShift: Date = Date()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let primaryContent = UIStoryboard(name: "GetShift", bundle: nil).instantiateViewController(withIdentifier: "PrimaryContentViewController")
        let drawerContent = UIStoryboard(name: "GetShift", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController")
        
        self.setPrimaryContentViewController(controller: primaryContent, animated: true)
        self.setDrawerContentViewController(controller: drawerContent, animated: false)
        
        setNeedsSupportedDrawerPositionsUpdate()
        setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
        passStoreMap()
        passStoreShift()
        setTitleChild(stores.storeDetail!.name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.embbedChildMapShiftSegueID.rawValue {
            let nextViewController = segue.destination as! MapShiftViewController
            nextViewController.stores = stores
        }else if segue.identifier == SeguesIdentifiers.openShiftUser.rawValue {
            let nextViewController = segue.destination as! ShiftInformationUserViewController
            nextViewController.line = self.lineSelected.id
            nextViewController.minutes = 2
            nextViewController.storeId = self.stores.storeDetail!.id
            nextViewController.stores = self.stores
            nextViewController.shift = self.shift
        }
    }
    
    /*func currentTimeInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }*/
    
    func dateInMiliseconds(value: Date) -> Int {
        let valueLocal = value.toLocalTime()
        let since1970 = valueLocal.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    func getParametersShift() {
        newShift.phoneNumber = number
        newShift.storeId = stores.storeDetail!.id
        newShift.virtualLineId = lineSelected.id
        newShift.shiftDateTime = dateInMiliseconds(value: dateShift)
        newShift.nextLine = false
        getShiftUser()
    }
    
    func getShift() {
        getParametersShift()
    }
    
    func getShiftUser() {
        APIVirtualLines.getUserShift(body: newShift).debug("APIVirtualLines.getShiftUser").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.shift = dataResponse
            self.performSegue(withIdentifier: SeguesIdentifiers.openShiftUser.rawValue, sender: self)
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getShiftUser()
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
    
    func showPickerDate(sender: UIButton) {
        let datePicker = ActionSheetDatePicker(title: "DateAndTime:", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: Date(), doneBlock: {
            picker, value, index in
            self.dateShift = value as! Date
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        let secondsInWeekMin: TimeInterval = 0 * 24 * 60 * 60;
        datePicker?.minimumDate = Date(timeInterval: -secondsInWeekMin, since: Date())
        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
        datePicker?.minuteInterval = 10
        
        datePicker?.show()
    }
    
    func pulleyCollapsed() {
        self.setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
    }
    
    func pulleyRevealed() {
        self.setDrawerPosition(position: PulleyPosition.partiallyRevealed, animated: true)
    }
    
    func pulleyOpen() {
        self.setDrawerPosition(position: PulleyPosition.open, animated: true)
    }
    
    func pulleyClose() {
        self.setDrawerPosition(position: PulleyPosition.closed, animated: true)
    }
    
    func passStoreMap() {
        let CVC = children.first as! MapShiftViewController
        CVC.stores = stores
        CVC.locateMap()
    }
    
    func passStoreShift() {
        let CVC = children[1] as! InfoShiftViewController
        CVC.stores = stores
        CVC.setupMaster()
    }
    
}

extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}
