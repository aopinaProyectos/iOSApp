//
//  MyRowsViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/7/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import ActionSheetPicker_3_0

class MyRowsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, cellDataRowDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var activeShift: ActiveShift = ActiveShift()
    var flagError: Bool = false
    var flagEmptyTable: Bool = false
    var reasonId: Int = 0
    var tagSlected: Int = 0
    var lineToUpdate: Int = 0
    var countToUpdate: Int = 0
    var idToUpdate: Int = 0
    var countActiveShift: Int = 0
    var shiftToUpdate: String = ""
    var tag: Int = 0
    var dateShift: Date = Date()
    var shifts: [ShiftsHistory] = [ShiftsHistory]()
    var stores: [DataStore] = [DataStore]()
    var store: DataStore = DataStore()
    var shiftUpdate: UpdateShift = UpdateShift()
    var myRows: [ShiftRows] = [ShiftRows]()
    
    let phone = AppInfo().phone
    let disposeBag: DisposeBag = DisposeBag()
    var timerUpdate: Timer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.setOpaqueNavigationBar()
        self.setTitleChild("Mis Lineas")
        tableView?.register(UINib(nibName: kdataRowCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kdataRowCellReuseIdentifier)
        tableView?.register(UINib(nibName: kEmptyRowCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kEmptyRowCellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = #colorLiteral(red: 0.9715679288, green: 0.9767023921, blue: 0.9850376248, alpha: 1)
        timerUpdate = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.getStatusShift), userInfo: nil, repeats: true)
        //loadShifts()
        //getAllShiftActive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countActiveShift = 0
        activeShift.shift = []
        timerUpdate?.invalidate()
        timerUpdate = nil
        getAllShiftActive()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openShiftInformationUser.rawValue {
            self.tabBarController?.tabBar.isHidden = true
            let nextViewController = segue.destination as! ShiftInformationUserViewController
            nextViewController.stores = stores[tagSlected]
            nextViewController.shift.shift = activeShift.shift![tagSlected]
            nextViewController.shift.shift?.totalPerson = activeShift.shift![tagSlected].totalPersons
        }
    }
    
    func loadShifts() {
        let shift = UserDefaults.standard.data(forKey: "Shifts")
        if shift != nil {
            let shiftHist = try! JSONDecoder().decode([ShiftsHistory].self, from: shift!)
            self.shifts = shiftHist
        }
        
    }
    
    func showCancel(tag: Int) {
        timerUpdate?.invalidate()
        self.navigationController?.navigationBar.isHidden = true
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "CancelShiftViewController") as! CancelShiftViewController
        self.view.addSubview(customAlert.view)
        customAlert.handlerGoToMenu = {
            self.reasonId = customAlert.reasonId
            self.cancelShift()
        }
        customAlert.handlerCloseView = {
            print ("Close")
        }
    }
    
    func showRate(tag: Int) {
        self.navigationController?.navigationBar.isHidden = true
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "RateStoreViewController") as! RateStoreViewController
        self.view.addSubview(customAlert.view)
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
        }
    }
    
    func createBadgets() {
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            let value = activeShift.shift?.count ?? 0
            if value > 0 {
                tabItem.badgeValue = "\(value ?? 0)"
            }else {
                tabItem.badgeValue = nil
            }
        }
    }

    func getAllShiftActive() {
        countActiveShift = 0
        APIVirtualLines.getAllShifts(phone: phone).debug("APIVirtualLines.getAllShiftActive").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.activeShift = dataResponse
            self.getInfoStore()
            self.createBadgets()
            //self.tableView.reloadData()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getAllShiftActive()
            case CatalogError.NoLinesFound(let response):
                self.createBadgets()
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
    
    func updateShiftInPlace(){
        APIVirtualLines.updateShiftInPlace(line: lineToUpdate, shift: shiftToUpdate).debug("UpdateShiftInPlace").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.getAllShiftActive()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.updateShiftInPlace()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func getInfoStore() {
        //var index = 0
        let turn = self.activeShift.shift
        /*self.myRows = [ShiftRows]()
        let row: ShiftRows = ShiftRows()
        
        row.shift = turn![0].shift
        
        
        for turno in turn! {
            let row: ShiftRows = ShiftRows()
            row.shift = turno.shift
            row.idLine = turno.virtualLineId
            row.idShift = turno.id
            row.idStore = turno.storeId
            row.status = turno.status
            row.shiftTime = turno.shiftTime
            row.store = getInformationStore(id: turno.storeId, index: index)
            self.myRows.append(row)
            
            index = index + 1
        }*/
        self.myRows = []
        getInformationStore(id: turn![countActiveShift].storeId)
    }
    
    func getInformationStore(id: Int) {
        APIVirtualLines.getStoreInformation(id: id).debug("APIVirtualLines.getAllShiftActive").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.store = DataStore()
            self.store.storeDetail = dataResponse.store
            self.stores.append(self.store)
            let turn = self.activeShift.shift
            let row: ShiftRows = ShiftRows()
            row.shift = turn![self.countActiveShift].shift
            row.idLine = turn![self.countActiveShift].virtualLineId
            row.idShift = turn![self.countActiveShift].id
            row.idStore = turn![self.countActiveShift].storeId
            row.status = turn![self.countActiveShift].status
            row.shiftTime = turn![self.countActiveShift].shiftTime
            row.store = dataResponse
            self.myRows.append(row)
            self.countActiveShift = self.countActiveShift + 1
            if self.myRows.count == turn?.count {
                self.tableView.reloadData()
                self.timerUpdate = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.getStatusShift), userInfo: nil, repeats: true)
            }else {
                self.getInformationStore(id: turn![self.countActiveShift].storeId)
            }
            //return dataResponse.store
            /*self.store = DataStore()
            self.store.storeDetail = dataResponse.store
            self.stores.append(self.store)
            self.myRows[index].addresStore = (dataResponse.store?.storeAddress!.street)!
            self.myRows[index].latitude = (dataResponse.store?.storeAddress!.lat)!
            self.myRows[index].longitude = (dataResponse.store?.storeAddress!.lng)!
            self.myRows[index].nameStore = (dataResponse.store?.name)!
            self.myRows[index].category = (dataResponse.store?.storeCategoryId)!
            if self.stores.count == self.myRows.count {
                self.tableView.reloadData()
            }
            self.updateShiftRows()*/
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getInformationStore(id: id)
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
    
    func updateShift() {
        let recTag = tagSlected
        let shi = self.myRows[recTag].idShift
        APIVirtualLines.updateShift(shiftId: shi).debug("APIVirtualLines.updateShift").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.shiftUpdate = dataResponse
            self.performSegue(withIdentifier: SeguesIdentifiers.openShiftInformationUser.rawValue, sender: self)
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.updateShift()
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
    
    func updateShiftRows() {
        APIVirtualLines.updateShift(shiftId: idToUpdate).debug("APIVirtualLines.updateShift").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.myRows[self.countToUpdate].next = dataResponse.next
            self.countToUpdate = self.countToUpdate + 1
            if self.myRows.count != self.countToUpdate {
                self.idToUpdate = self.myRows[self.countToUpdate].idShift
                self.updateShiftRows()
            }else {
                self.countToUpdate = 0
                self.tableView.reloadData()
            }
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.updateShiftRows()
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
    
    
    func completeShift(tag: Int) {
        let recTag = tag
        let shi = self.myRows[tag].idShift
        let lin = self.myRows[tag].idLine
        APIVirtualLines.completeShift(shift: shi, line: lin).debug("APIVirtualLines.completeShift").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.showRate(tag: tag)
            self.myRows.remove(at: tag)
            self.tableView.reloadData()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.completeShift(tag: recTag)
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
    
    func cancelShift() {
        let recTag = tag
        let shi = self.myRows[tag].idShift
        let lin = self.myRows[tag].idLine
        let reason = reasonId
        APIVirtualLines.cancelShift(shift: shi, line: lin, reason: reason).debug("APIVirtualLines.cancelShift").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.myRows.remove(at: self.tag)
            self.tableView.reloadData()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.cancelShift()
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
        let secondsInWeekMin: TimeInterval = 0;
        datePicker?.minimumDate = Date(timeInterval: -secondsInWeekMin, since: Date())
        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
        datePicker?.minuteInterval = 10
        
        datePicker?.show()
    }
    
    func pressStatus(sender: UIButton) {
        lineToUpdate = myRows[sender.tag].idLine
        shiftToUpdate = "\(myRows[sender.tag].idShift)"
        switch myRows[sender.tag].status {
        case "VIGENTE":
            updateShiftInPlace()
        case "CLIENTE EN EL NEGOCIO":
            completeShift(tag: sender.tag)
        default:
            break
        }
    }
    
    func pressCancel(sender: UIButton) {
        tag = sender.tag
        let acp = ActionSheetMultipleStringPicker(title: "¿Por que deseas cancelar?", rows:
            [["No creo llegar", "Hay un cambio de Planes", "Olvide el Turno", "Otra Razón"]], initialSelection: [0, 0], doneBlock: {
                picker, values, indexes in
                var val = ""
                val = values!.description
                switch val {
                case "[0]":
                    self.reasonId = 2
                    self.cancelShift()
                case "[1]":
                    self.reasonId = 3
                    self.cancelShift()
                case "[2]":
                    self.reasonId = 7
                    self.cancelShift()
                case "[3]":
                    self.reasonId = 6
                    self.cancelShift()
                default:
                    break
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        acp?.show()
        //showCancel(tag: sender.tag)
    }
    
    @objc func getStatusShift() {
        let turn =  self.myRows
        if turn.count != 0 {
            idToUpdate = turn[countToUpdate].idShift
            updateShiftRows()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myRows.count != 0 {
            self.flagEmptyTable = false
            return self.myRows.count
        }else {
            self.flagEmptyTable = true
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if flagEmptyTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyRowViewCell", for: indexPath) as! emptyRowViewCell
            cell.setupView()
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataRowViewCell", for: indexPath) as! dataRowViewCell
            cell.selectionStyle = .none
            cell.cellDelegate = self
            cell.setupCell(info: self.myRows[indexPath.row], tag: indexPath.row, status: self.myRows[indexPath.row].status)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !flagEmptyTable {
            tagSlected = indexPath.row
            updateShift()
        }
    }
}
