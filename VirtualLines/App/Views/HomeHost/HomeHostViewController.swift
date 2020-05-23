//
//  HomeHostViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import ImageSlideshow
import RxSwift
import ActionSheetPicker_3_0
import CircleMenu


class HomeHostViewController: CustomTabBarViewController, UITableViewDelegate, UITableViewDataSource, CircleMenuDelegate {
    
    @IBOutlet weak var shiiftLabel: UILabel!
    @IBOutlet weak var shiftNameLabel: UILabel!
    @IBOutlet weak var shiftStatusLabel: UILabel!
    @IBOutlet weak var attendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linePicker: PickerVirtualLines!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonCircleMenu: CircleMenu!
    
    
    var stores: [StoreDetail] = [StoreDetail]()
    var storeSelected: StoreDetail = StoreDetail()
    var lineSelected: InfoLine = InfoLine()
    var shiftCriteria: CriteriaShifts = CriteriaShifts()
    var shift: ManageShift = ManageShift()
    var line: LineCreated = LineCreated()
    
    var lineToPass: Int = 0
    var shiftToPass: String = ""
    var reasonToPass: Int = 0
    
    var flagShiftEmpty = true
    var flagPassEmpty = true
    
    var lin: [InfoLine]? {
        didSet {
            guard let line = self.lin,
                let lin = line.first
                else { return }
            
            self.linePicker.items = line.map { $0.virtualLine}
            self.linePicker.selectedItem = line.first?.virtualLine
            self.lineSelected = line.first!
            AppInfo().lineName = (line.first?.virtualLine)!
            AppInfo().minPeople = (line.first?.minPersons)!
            AppInfo().maxPeople = (line.first?.maxPersons)!
            AppInfo().TSTime = (line.first?.serviceTime)!
            AppInfo().ToleranceTime = (line.first?.userDelayTolerance)!
        }
    }
    
    let items: [(icon: String, color: UIColor)] = [
        ("AddStore", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),
        ("Analytics", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1)),
        ("ProfileStore", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1))
    ]
    
    let middleButton = UIButton.init(type: .custom)
    let button = UIButton(type: .system)
    
    
    
    
    
    
    
    
    
    
    private var mainView: MainView!
    private var didSetupConstraints = false
    
    var cat: [Category]? = [Category]()
    var optionsMenu: [optionMenu]? = [optionMenu]()
    var addressArray: [AddressUser] = [AddressUser]()
    var categorySelected: Int = 0
    var index: Int = 0
    var selectedAddress = ""
    var phone = AppInfo().phone
    var emptyAddress = false
    var comeFromPop = false
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarSwipe(enabled: false)
        linePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: kDataShiftHostViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataShiftHostViewCellReuseIdentifier)
        tableView?.register(UINib(nibName: kEmptyDataShiftHostViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kEmptyDataShiftHostViewCellReuseIdentifier)
        let imgCircle = resizeImage(image: UIImage(named: "Business")!, targetSize: CGSize(width: 40, height: 40))
        let imgCircleSelect = resizeImage(image: UIImage(named: "Close")!, targetSize: CGSize(width: 20, height: 20))
        buttonCircleMenu.setImage(imgCircle.tinted(with: kColorButtonActive), for: .normal)
        buttonCircleMenu.setImage(imgCircleSelect.tinted(with: .white), for: .selected)
        buttonCircleMenu.layer.cornerRadius = 30
        buttonCircleMenu.backgroundColor = UIColor.white
        
        
        //getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupBar()
        getStores()
        self.showTabBar()
        self.setOpaqueNavigationBar()
        createButtonBarRight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        middleButton.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openStoreHost.rawValue {
            let viewController = segue.destination as! StoresHostViewControllers
            viewController.stores = stores
        }else if segue.identifier == SeguesIdentifiers.openRegisterHost.rawValue {
            let viewController = segue.destination as! RegisterHostNameViewController
            viewController.comeFromMenu = true
        }else if segue.identifier == SeguesIdentifiers.openProfileHost.rawValue {
            let viewController = segue.destination as! ProfileHostViewController
            viewController.id = storeSelected.id
        }
            
    }
    
    func getStores(){
        APIVirtualLines.getAllStoreHost(number: phone).debug("GetAllStoreHost").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.stores = dataResponse.stores!
            self.createButton()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getStores()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func createLine(){
        APIVirtualLines.createLine(store: storeSelected.id, line: line).debug("CreateLine").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.getAllLines()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.createLine()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func updateLine(){
        APIVirtualLines.updateLine(store: storeSelected.id, line: line).debug("UpdateLine").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.getAllLines()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.updateLine()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func getAllLines(){
        APIVirtualLines.getAllLines(storeId: storeSelected.id).debug("GetAllLinesHost").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.lin = dataResponse.virtualLines
            self.getParametersShift()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getAllLines()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func getParametersShift() {
        var arrayStatus = [Int]()
        arrayStatus.append(KStatusVigente)
        arrayStatus.append(kStatusEnSitio)
        self.shiftCriteria.criteria.storeId = storeSelected.id
        self.shiftCriteria.criteria.virtualLineId = lineSelected.id
        self.shiftCriteria.criteria.status = arrayStatus
        self.getAllShifts()
    }
    
    func getAllShifts(){
        APIVirtualLines.getAllShift(criteria: shiftCriteria).debug("GetAllLinesHost").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.shift = dataResponse
            if self.shift.stores!.count < 2 {
                self.flagShiftEmpty = true
                if self.shift.stores?.count == 0 {
                    self.flagPassEmpty = true
                }else {
                    self.flagPassEmpty = false
                }
            }else {
                self.flagShiftEmpty = false
            }
            self.setupTableView()
            self.setupShift()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getAllLines()
            case CatalogError.NotFoundPlaces:
                self.flagPassEmpty = true
                self.flagShiftEmpty = true
                self.setupShift()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func completeShift(){
        APIVirtualLines.completeShiftByHost(line: lineToPass, shift: shiftToPass).debug("CompleteShiftByHost").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.getAllShifts()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.completeShift()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func cancelShift() {
        APIVirtualLines.cancelShift(shift: Int(shiftToPass)!, line: lineToPass, reason: reasonToPass).debug("CancelShiftByHost").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.getAllShifts()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.cancelShift()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func showCancel() {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "CancelShiftViewController") as! CancelShiftViewController
        //CustomTabBarViewController.addChild(customAlert.view)
        //CustomTabBarViewController.add
        view.addSubview(customAlert.view)
        customAlert.handlerGoToMenu = {
            self.cancelShift()
        }
        customAlert.handlerCloseView = {
            print ("Close")
        }
    }
    
    func setupShift() {
        if flagPassEmpty {
            shiiftLabel.text = ""
            shiftNameLabel.text = "No hay turnos"
            shiftStatusLabel.text = ""
            lineToPass = 0
            shiftToPass = ""
            attendButton.backgroundColor = kColorButtonInactive
            cancelButton.setTitleColor(kColorInactive, for: .normal)
            attendButton.isEnabled = false
            cancelButton.isEnabled = false
        }else {
            shiiftLabel.text = shift.stores?.first?.shiftData?.shift
            shiftNameLabel.text = shift.stores?.first?.userContactInfo?.name
            shiftStatusLabel.text = applyLocalizationStatus(status: (shift.stores?.first?.shiftData!.status)!)
            lineToPass = (shift.stores?.first?.shiftData!.virtualLineId)!
            shiftToPass = "\((shift.stores?.first?.shiftData!.id)!)"
            attendButton.backgroundColor = kColorButtonActive
            cancelButton.setTitleColor(.red, for: .normal)
            attendButton.isEnabled = true
            cancelButton.isEnabled = true
        }
    }
    
    func showLinesAlert(flag: Bool) {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "CreateLineViewControlle") as! CreateLineViewControlle
        if flag {
            customAlert.flagUpdate = flag
        }else {
            customAlert.flagUpdate = flag
        }
        view.addSubview(customAlert.view)
        
        customAlert.handlerCloseUpdateView = {
            self.line.id = self.lineSelected.id
            self.line.active = 1
            self.line.virtualLine = AppInfo().lineName
            self.line.minPersons = AppInfo().minPeople
            self.line.maxPersons = AppInfo().maxPeople
            self.line.serviceTime = AppInfo().TSTime
            self.line.userDelayTolerance = AppInfo().ToleranceTime
            self.updateLine()
            customAlert.view.removeFromSuperview()
        }
        
        customAlert.handlerCloseView = {
            self.line.active = 1
            self.line.virtualLine = AppInfo().lineName
            self.line.minPersons = AppInfo().minPeople
            self.line.maxPersons = AppInfo().maxPeople
            self.line.serviceTime = AppInfo().TSTime
            self.line.userDelayTolerance = AppInfo().ToleranceTime
            self.createLine()
            customAlert.view.removeFromSuperview()
        }
    }
    
    func createButtonBarRight() {
        let image = resizeImage(image: UIImage(named: "AddLine")!, targetSize: CGSize(width: 20, height: 20)).tinted(with: UIColor.white)
        let rightBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(tappedAddLine))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func tappedAddLine() {
        showLinesAlert(flag: false)
    }
    
    @IBAction func editLinePressed() {
        showLinesAlert(flag: true)
    }
    
    func createButton() {
        var title = ""
        let image = resizeImage(image: UIImage(named: "Restaurants")!, targetSize: CGSize(width: 15, height: 15))
        if AppInfo().storeIdSelectedHost > 0 {
            storeSelected = stores[AppInfo().storeIdSelectedHost - 1]
            title = "   " + storeSelected.name + " ▼"
        }else {
            storeSelected = stores.first!
            title = "   " + stores.first!.name + " ▼"
        }
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        //button.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.titleView = button
        getAllLines()
    }
    
    func setupTableView() {
        tableView.reloadData()
    }
    
    func setupBar(){
        var imageOrigin: UIImage = UIImage()
        if AppInfo().isUserHost {
            imageOrigin = self.resizeImage(image: UIImage(named: "Business")!, targetSize: CGSize(width: 45, height: 45))
        }else {
            imageOrigin = self.resizeImage(image: UIImage(named: "StoreTB")!, targetSize: CGSize(width: 45, height: 45))
        }
        let image = imageOrigin.tinted(with: #colorLiteral(red: 0.3621281683, green: 0.3621373773, blue: 0.3621324301, alpha: 1))
        let imageSelect = imageOrigin.tinted(with: #colorLiteral(red: 0.3111690581, green: 0.5590575933, blue: 0.8019174337, alpha: 1))
        middleButton.setImage(image, for: .normal)
        middleButton.setImage(imageSelect, for: .selected)
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = UIColor.white
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 10)
        middleButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.tabBarController?.tabBar.addSubview(middleButton)
        self.tabBarController?.tabBar.centerXAnchor.constraint(equalTo: middleButton.centerXAnchor).isActive = true
        self.tabBarController?.tabBar.topAnchor.constraint(equalTo: middleButton.centerYAnchor).isActive = true
        middleButton.isSelected = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flagShiftEmpty {
            return 1
        }else if shift.stores!.count > 3 {
            return 3
        }else {
            return shift.stores!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if flagShiftEmpty {
            let cellDefault = tableView.dequeueReusableCell(withIdentifier: "emptyDataShiftHostViewCell") as! emptyDataShiftHostViewCell
            cellDefault.setupView()
            return cellDefault
        }else {
            let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataShiftHostViewCell") as! dataShiftHostViewCell
            cellDefault.setupView(shift: self.shift.stores![indexPath.row].shiftData!, name: self.shift.stores![indexPath.row].userContactInfo!.name)
            return cellDefault
        }
    }
    
    // MARK: <CircleMenuDelegate>
    
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        let image = resizeImage(image: UIImage(named: items[atIndex].icon)!, targetSize: CGSize(width: 30, height: 30))
        button.setImage(image.tinted(with: .white), for: .normal)
        
        // set highlited image
        let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
    }
    
    func circleMenu(_: CircleMenu, buttonWillSelected _: UIButton, atIndex: Int) {
        switch atIndex {
        case 0:
            self.performSegue(withIdentifier: SeguesIdentifiers.openRegisterHost.rawValue, sender: self)
        case 1:
            print ("Analytics")
        case 2:
            self.performSegue(withIdentifier: SeguesIdentifiers.openProfileHost.rawValue, sender: self)
        default:
            break
        }
    }
    
    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
    }
    
    @IBAction func acceptButtonPressed() {
        completeShift()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        let acp = ActionSheetMultipleStringPicker(title: "¿Por que deseas cancelar?", rows:
            [["No ha llegado el usuario", "Otra Razón"]], initialSelection: [0, 0], doneBlock: {
                picker, values, indexes in
                var val = ""
                val = values!.description
                switch val {
                case "[0]":
                    self.reasonToPass = 8
                    self.cancelShift()
                case "[1]":
                    self.reasonToPass = 6
                    self.cancelShift()
                default:
                    break
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        acp?.show()
        //showCancel()
    }
    
    @objc func didTapOnButton() {
        self.performSegue(withIdentifier: SeguesIdentifiers.openStoreHost.rawValue, sender: self)
    }
    
    @objc func buttonAction() {
        middleButton.isSelected = true
        self.tabBarController?.selectedIndex = 2
    }
    
}

extension HomeHostViewController : PickerVirtualLinesDelegate {
    func didSelect(_ sender: PickerVirtualLines, index: Int) {
        if sender == self.linePicker {
            self.lineSelected = (lin?[index])!
            AppInfo().lineName = (lineSelected.virtualLine)
            AppInfo().minPeople = (lineSelected.minPersons)
            AppInfo().maxPeople = (lineSelected.maxPersons)
            AppInfo().TSTime = (lineSelected.serviceTime)
            AppInfo().ToleranceTime = (lineSelected.userDelayTolerance)
            getParametersShift()
        }
    }
}

extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            red: 1.0 / 255.0 * CGFloat(red),
            green: 1.0 / 255.0 * CGFloat(green),
            blue: 1.0 / 255.0 * CGFloat(blue),
            alpha: CGFloat(alpha))
    }
}
