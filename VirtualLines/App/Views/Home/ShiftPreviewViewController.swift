//
//  ShiftPreviewViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/14/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import RxSwift
import Alamofire
import MapKit
import SkeletonView

class ShiftPreviewViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var nameStoreLabel: UILabel!
    @IBOutlet weak var linePicker: PickerVirtualLines!
    @IBOutlet weak var capacityImage: UIImageView!
    @IBOutlet weak var shiftWaitImage: UIImageView!
    @IBOutlet weak var timeWaitImage: UIImageView!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var shiftLabel: UILabel!
    @IBOutlet weak var timeWaitingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeRoadLabel: UILabel!
    @IBOutlet weak var motorButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var addreessName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewLine: UIView!
    
    var lat: Double = 0
    var lon: Double = 0
    var storeLat: Double = 0
    var storeLong: Double = 0
    var storeId: Int = 0
    var minutesShift: Int = 0
    var indexLineSelected: Int = 0
    var number = AppInfo().phone
    var modeTransport: String = ""
    
    var flagError: Bool = false
    
    var stores: DataStore = DataStore()
    var route: Routes = Routes()
    var timeArrival: TimeArrival = TimeArrival()
    var road: Directions = Directions()
    var time: DirectionsTime = DirectionsTime()
    var lineSelected: InfoShift = InfoShift()
    var shift: ShiftUser = ShiftUser()
    var newShift: ShiftNewTurn = ShiftNewTurn()
    var lines: [InfoShift] = [InfoShift]()
    
    var lin: [InfoShift]? {
        didSet {
            guard let line = self.lin,
                let lin = line.first
                else { return }
            
            self.linePicker.items = line.map { $0.name }
            self.linePicker.selectedItem = line.first?.name
            self.lineSelected = line.first!
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        lat = AppInfo().userLat
        lon = AppInfo().userLong
        modeTransport = "driving"
        mapView.delegate = self
        linePicker.delegate = self
        storeLat = (stores.storeDetail?.storeAddress!.lat)!
        storeLong = (stores.storeDetail?.storeAddress!.lng)!
        storeId = stores.storeDetail!.id
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getParameters()
        self.getParametersTime()
        self.getInfoLine()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openShiftUser.rawValue {
            let nextViewController = segue.destination as! ShiftInformationUserViewController
            nextViewController.line = self.lineSelected.id
            nextViewController.minutes = self.minutesShift
            nextViewController.storeId = self.storeId
            nextViewController.stores = self.stores
            nextViewController.shift = self.shift
        }
    }
    
    func setupView() {
        linePicker.view.backgroundColor = #colorLiteral(red: 0, green: 0.7061205506, blue: 0, alpha: 1)
        linePicker.pickerColor = UIColor.white
        storeImage.image = UIImage(named: "Restaurants")
        storeImage.addBlur()
        //storeImage.alpha = 0.5
        nameStoreLabel.text = stores.storeDetail?.name
        addreessName.text = AppInfo().addressName
        addressImage.image = getImageAddress(named: AppInfo().addressName)
        scheduleLabel.text = getSchedule()
        addressLabel.text = stores.storeDetail?.storeAddress?.street
        capacityLabel.text = String(lineSelected.serviceLimit)
        shiftLabel.text = String(lineSelected.shifts)
        timeWaitingLabel.text = String(lineSelected.serviceWaitTime)
        distanceLabel.text = String(stores.distance)
    }
    
    func getSchedule() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        switch dayInWeek.lowercased() {
        case Message.MONDAY.localized.lowercased():
            return (stores.storeDetail?.schedules.monday)!
        case Message.TUESDAY.localized.lowercased():
            return (stores.storeDetail?.schedules.tuesday)!
        case Message.WEDNESDAY.localized.lowercased():
            return (stores.storeDetail?.schedules.wednesday)!
        case Message.THURSDAY.localized.lowercased():
            return (stores.storeDetail?.schedules.thursday)!
        case Message.FRIDAY.localized.lowercased():
            return (stores.storeDetail?.schedules.friday)!
        case Message.SATURDAY.localized.lowercased():
            return (stores.storeDetail?.schedules.saturday)!
        case Message.SUNDAY.localized.lowercased():
            return (stores.storeDetail?.schedules.sunday)!
        default:
            return ""
        }
        
    }
    
    func getImageAddress(named: String) -> UIImage{
        switch named {
        case "Casa":
            return resizeImage(image: UIImage(named: "HouseSelected")!, targetSize: CGSize(width: 22, height: 25))
        case "Oficina":
            return resizeImage(image: UIImage(named: "OfficeSelected")!, targetSize: CGSize(width: 22, height: 25))
        case "Otro":
            return resizeImage(image: UIImage(named: "OtherSelected")!, targetSize: CGSize(width: 22, height: 25))
        case "Novi@":
            return resizeImage(image: UIImage(named: "GirlfriendSelected")!, targetSize: CGSize(width: 22, height: 25))
        default:
            return resizeImage(image: UIImage(named: "OtherSelected")!, targetSize: CGSize(width: 22, height: 25))
        }
    }
    
    func setupMap() {
        mapView.clear()
        let store_marker = GMSMarker()
        store_marker.position = CLLocationCoordinate2D(latitude: storeLat, longitude: storeLong)
        store_marker.title = stores.storeDetail?.name
        store_marker.snippet = "Establecimiento"
        store_marker.map = mapView
        
        let user_marker = GMSMarker()
        user_marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        user_marker.title = AppInfo().addressName
        user_marker.snippet = "Aqui estas"
        user_marker.map = mapView
        
        for poly in road.data!.route1 {
            drawPath(from: poly)
        }
        
        
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.red
        if modeTransport == "walking" {
            let strokeStyles = [GMSStrokeStyle.solidColor(.red), GMSStrokeStyle.solidColor(.clear)]
            let strokeLengths = [NSNumber(value: 10), NSNumber(value: 10)]
            polyline.spans = GMSStyleSpans(path!, strokeStyles, strokeLengths, .rhumb)
        }
        polyline.map = mapView // Google MapView
        let bounds = GMSCoordinateBounds(path: path!)
        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
    }
    
    func getInfoLine() {
        APIVirtualLines.getInfoShift(storeId: self.storeId).debug("APIVirtualLines.getInfoLine").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.lin = dataResponse.virtualLines!
            self.lines = dataResponse.virtualLines!
            self.setupView()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getTokenRenew()
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
    
    func getParameters() {
        route.origin.lat = AppInfo().userLat
        route.origin.lng = AppInfo().userLong
        route.destination.lat = (stores.storeDetail?.storeAddress!.lat)!
        route.destination.lng = (stores.storeDetail?.storeAddress!.lng)!
        route.tripMode = modeTransport
        getRoutes()
    }
    
    func getParametersTime() {
        let dest = DestinationTime()
        dest.destination.lat = (stores.storeDetail?.storeAddress!.lat)!
        dest.destination.lng = (stores.storeDetail?.storeAddress!.lng)!
        dest.storeId = storeId
        timeArrival.destination.append(dest)
        timeArrival.origin.lat = AppInfo().userLat
        timeArrival.origin.lng = AppInfo().userLong
        timeArrival.tripMode = modeTransport
        getTimeArrival()
    }
    
    /*func getParametersShift() {
        minutesShift = 2 //Int(self.time.data[0].duration.prefix(1))! + 5
        newShift.minutes = minutesShift
        newShift.phoneNumber = number
        newShift.storeId = storeId
        newShift.virtualLine = lineSelected.id
        getShiftUser()
    }*/
    
    func setupTime() {
        self.timeRoadLabel.text = time.data[0].duration
        self.distanceLabel.text = time.data[0].distance
    }
    
    func getTimeArrival() {
        APIVirtualLines.getTimeArrival(body: timeArrival).debug("APIVirtualLines.getTimeArrival").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.time = dataResponse
            self.setupTime()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getTimeArrival()
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
    
    
    func getRoutes() {
        APIVirtualLines.getRoutes(body: route, number: number).debug("APIVirtualLines.getInfoLine").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.road = dataResponse
            self.setupMap()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getRoutes()
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
    
    func getShiftUser() {
        APIVirtualLines.getUserShift(body: newShift).debug("APIVirtualLines.getShiftUser").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.shift = dataResponse
            //self.loadShifts()
            //self.saveShifts()
            self.performSegue(withIdentifier: SeguesIdentifiers.openShiftUser.rawValue, sender: self)
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getTokenRenew()
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
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 20.0)
        self.mapView.camera = camera
    }
    
    @IBAction func carButtonPressed() {
        modeTransport = "driving"
        getParametersTime()
        getParameters()
    }
    
    @IBAction func bicycleButtonPressed() {
        modeTransport = "bicycling"
        getParametersTime()
        getParameters()
    }
    
    @IBAction func walkingButtonPressed() {
        modeTransport = "walking"
        getParametersTime()
        getParameters()
    }
    
    @IBAction func nextButtonPressed() {
        //getParametersShift()
    }
    
    
}

extension ShiftPreviewViewController : PickerVirtualLinesDelegate {
    func didSelect(_ sender: PickerVirtualLines, index: Int) {
        if sender == self.linePicker {
            self.lineSelected = (lin?[index])!
            self.setupView()
        }
    }
}
