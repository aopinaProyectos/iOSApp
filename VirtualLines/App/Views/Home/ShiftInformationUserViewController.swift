//
//  ShiftInformationUserViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/28/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import MapKit
import Alamofire
import AlamofireImage
import ImageSlideshow
import ActionSheetPicker_3_0


class ShiftInformationUserViewController: UIViewController {
    
    @IBOutlet weak var shiftUserLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeArriveLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var goToMapButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var imageStore: UIImageView!
    @IBOutlet weak var nameStoreLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var viewSlideImages: ImageSlideshow!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var totalPerson: UILabel!
    
    var timeArrive: String = ""
    var storeId: Int = 0
    var line: Int = 0
    var minutes: Int = 0
    var latStore: Double = 0
    var lonStore: Double = 0
    var userLat: Double = 0
    var userLon: Double = 0
    var reasonId: Int = 0
    var dateShift: Date = Date()
    var flagError: Bool = false
    var images: [images] = []
    var imagesSource = [InputSource]()
    var category = 0
    var shift: ShiftUser = ShiftUser()
    var stores: DataStore = DataStore()
    var shiftUpdate: UpdateShift = UpdateShift()
    var timerUpdate: Timer? = nil
    
    let phone = AppInfo().phone
    let disposeBag: DisposeBag = DisposeBag()
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        
        latStore = (stores.storeDetail?.storeAddress!.lat)!
        lonStore = (stores.storeDetail?.storeAddress!.lng)!
        userLat = AppInfo().userLat
        userLon = AppInfo().userLong
        
        checkExpiredShift()
        self.setupView()
        self.setupNextPerson()
        self.setupButtons()
        createButtonBarRight()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.leftBarButtonItem?.action = #selector(self.back(sender:))
        self.navigationItem.leftBarButtonItem?.target = self
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            if AppInfo().isUserHost {
                UIStoryboard.loadMenuHost()
            } else {
                UIStoryboard.loadMenu()
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            showAlertCode()
        }
    }
    
    func createButtonBarRight() {
        let image = resizeImage(image: UIImage(named: "CodeQR")!, targetSize: CGSize(width: 20, height: 20)).tinted(with: UIColor.white)
        let rightBarButtonItem = UIBarButtonItem.init(image: image, style: .done, target: self, action: #selector(tappedCodeQR))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func checkExpiredShift() {
        let date = Date()
        let dateStr = "\((self.shift.shift!.shiftDate + 1))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateShift = dateFormatter.date(from: dateStr)
        if date > dateShift! {
            self.expiredLabel.isHidden = false
            self.statusButton.isHidden = true
            self.shiftUserLabel.textColor = UIColor.lightGray
        }else {
            timerUpdate = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.getStatusShift), userInfo: nil, repeats: true)
        }
    }
    
    func getImages() {
        images = stores.storeDetail!.images
        category = stores.storeDetail!.storeCategoryId
        if images.count == 0 {
            let image = imageBack(category: category)
            imagesSource.append(ImageSource(image: image))
        }else {
            for image in images {
                downloadImage(url: image.url, category: category)
            }
        }
    }
    
    func downloadImage(url: String, category: Int) {
        let imageUrl = URL(string: url)
        Alamofire.request(imageUrl!, method: .get).responseImage { response in
            guard let image = response.result.value else {
                self.imagesSource.append(ImageSource(image: self.imageBack(category: category)))
                self.configureSlideView()
                return
            }
            let imageURL = self.resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
            self.imagesSource.append(ImageSource(image: imageURL))
            self.configureSlideView()
        }
    }
    
    func imageBack(category: Int) -> UIImage {
        switch category {
        case 1:
            return UIImage(named: "Banks")!
        case 2:
            return UIImage(named: "Restaurants")!
        case 3:
            return UIImage(named: "Enterteinment")!
        case 4:
            return UIImage(named: "Health")!
        case 5:
            return UIImage(named: "Education")!
        case 6:
            return UIImage(named: "Pets")!
        default:
            return UIImage(named: "Restaurants")!
        }
    }
    
    private func configureSlideView(){
        viewSlideImages.setImageInputs(imagesSource)
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
    
    func setupView() {
        getImages()
        setTitleChild(stores.storeDetail!.name)
        self.totalPerson.text = "\(shift.shift?.totalPerson ?? 0)" + " Personas en espera"
        self.nameStoreLabel.text = "  " + self.shift.shift!.virtualLineName
        self.timeArriveLabel.text = self.shift.shift?.shiftTime
        self.shiftUserLabel.text = self.shift.shift?.shift
        self.statusButton.setTitle("¿Ya te atendierón?", for: .normal)
    }
    
    func setupNextPerson() {
        if shift.shift!.totalPerson > 1 {
            let text = "\(shift.shift?.totalPerson ?? 1)"
            statusLabel.text = "Personas en espera: " + text
        }else {
            statusLabel.text = "¡Eres el siguiente!"
        }
    }
    
    func completeShift() {
        let shi = self.shift.shift?.id
        let lin = self.shift.shift?.virtualLineId
        APIVirtualLines.completeShift(shift: shi!, line: lin!).debug("APIVirtualLines.completeShift").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.showRate()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.completeShift()
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
        let shi = self.shift.shift?.id
        let lin = self.shift.shift?.virtualLineId
        let reason = reasonId
        APIVirtualLines.cancelShift(shift: shi!, line: lin!, reason: reason).debug("APIVirtualLines.completeShift").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            UIStoryboard.loadMenu()
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
    
    func updateShift() {
        let shiftId = shift.shift?.id
        APIVirtualLines.updateShift(shiftId: shiftId!).debug("APIVirtualLines.getUpdateShift").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.shiftUpdate = dataResponse
            self.setupUpdate()
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
    
    func setupUpdate() {
        self.statusButton.setTitle("¿Ya te atendierón?", for: .normal)
        statusLabel.isHidden = !shiftUpdate.next
    }
    
    func showAlertCode() {
        timerUpdate?.invalidate()
        self.navigationController?.navigationBar.isHidden = true
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "CodeQRViewController") as! CodeQRViewController
        customAlert.storeName = stores.storeDetail!.name
        customAlert.timeShift = shift.shift!.shiftTime
        customAlert.urlQR = shift.shift!.urlQRCode
        customAlert.shift = shift.shift!
        UIApplication.shared.keyWindow?.addSubview(customAlert.view)
        addChild(customAlert)
        //self.view.addSubview(customAlert.view)
        //UIApplication.shared.keyWindow?.addSubview(customAlert.view)
        customAlert.handlerCloseView = {
            self.timerUpdate = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.getStatusShift), userInfo: nil, repeats: true)
            self.createButtonBarRight()
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    func showRate() {
        self.navigationController?.navigationBar.isHidden = true
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "RateStoreViewController") as! RateStoreViewController
        self.view.addSubview(customAlert.view)
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
            UIStoryboard.loadMenu()
        }
    }
    
    func setupButtons() {
        let imageMap = resizeImage(image: UIImage(named: "MapsShift")!, targetSize: CGSize(width: 20, height: 20))
        let imageCancel = resizeImage(image: UIImage(named: "Cancel")!, targetSize: CGSize(width: 20, height: 20))
        let imageReschedule = resizeImage(image: UIImage(named: "RescheduleShift")!, targetSize: CGSize(width: 20, height: 20))
        /*goToMapButton.setTitle("   LLevame a " + stores.storeDetail!.name, for: .normal)
        goToMapButton.setImage(imageMap, for: .normal)
        goToMapButton.semanticContentAttribute = .forceLeftToRight
        goToMapButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.setTitle("   Deseo Cancelar", for: .normal)
        cancelButton.setImage(imageCancel, for: .normal)
        cancelButton.semanticContentAttribute = .forceLeftToRight
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        rescheduleButton.setTitle("   Deseo Reagendar", for: .normal)
        rescheduleButton.setImage(imageReschedule, for: .normal)
        rescheduleButton.semanticContentAttribute = .forceLeftToRight
        rescheduleButton.translatesAutoresizingMaskIntoConstraints = false*/
    }
    
    func showCancel() {
        self.navigationController?.navigationBar.isHidden = true
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "CancelShiftViewController") as! CancelShiftViewController
        self.view.addSubview(customAlert.view)
        customAlert.handlerGoToMenu = {
            self.reasonId = customAlert.reasonId
            self.cancelShift()
        }
        customAlert.handlerCloseView = {
            UIStoryboard.loadMenu()
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
                self.navigationController?.popViewController(animated: true)
            }else {
                customAlert.view.removeFromSuperview()
            }
            
        }
    }
    
    func showPickerDate(sender: UIButton) {
        let datePicker = ActionSheetDatePicker(title: "Reagendar:", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: Date(), doneBlock: {
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
    
    func pressSchedule(_ sender: UIButton) {
        showPickerDate(sender: sender)
    }
    
    func openMapForPlace() {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLon)))
        source.name = "Estas aquí"
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latStore, longitude: lonStore)))
        destination.name = stores.storeDetail?.name
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func buttonPressed() {
        completeShift()
    }
    
    @IBAction func goToMap() {
        openMapForPlace()
    }
    
    @IBAction func cancel() {
        showCancel()
    }
    
    @IBAction func reschedule(_ sender: UIButton) {
        pressSchedule(sender)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        UIStoryboard.loadMenu()
    }
    
    @objc func tappedCodeQR() {
        showAlertCode()
    }
    
    @objc func getStatusShift() {
        updateShift()
    }
}
