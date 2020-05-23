//
//  ShiftInformationViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/24/19.
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

class ShiftInformationViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    //@IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var motorbikeButton: UIButton!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRoadLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var turnButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pickerLines: PickerVirtualLines!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var timeRoadIcon: UIImageView!
    @IBOutlet weak var distanceIcon: UIImageView!
    @IBOutlet weak var lineInstruct: UILabel!
    
    var lat: Double = 0
    var lon: Double = 0
    var storeLat: Double = 0
    var storeLong: Double = 0
    var storeId: Int = 0
    var hourShift: Int = 0
    var minutesShift: Int = 0
    var mapIsLoaded: Bool = false
    var flagWalk: Bool = false
    var flagError: Bool = false
    
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var lineSelected: InfoShift = InfoShift()
    var lines: [InfoShift] = [InfoShift]()
    var images: [UIImage] = [UIImage]()
    var stores: DataStore = DataStore()
    var shifts: [ShiftsHistory] = [ShiftsHistory]()
    var shift: ShiftUser = ShiftUser()
    
    var lin: [InfoShift]? {
        didSet {
            guard let line = self.lin,
                let lin = line.first
                else { return }
            
            self.pickerLines.items = line.map { $0.name }
            self.pickerLines.selectedItem = line.first?.name
            self.lineSelected = line.first!
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        skeletonView()
        storeLat = (stores.storeDetail?.storeAddress!.lat)!
        storeLong = (stores.storeDetail?.storeAddress!.lng)!
        self.pickerLines.delegate = self
        self.storeId = stores.storeDetail!.id
        //getInfoLine()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getInfoLine()
        storeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
    
    func skeletonView() {
        storeImageView.showAnimatedSkeleton()
        storeNameLabel.showAnimatedSkeleton()
        storeAddressLabel.showAnimatedSkeleton()
        mapView.showAnimatedSkeleton()
        mapView.isHidden = true
        carButton.showAnimatedSkeleton()
        motorbikeButton.showAnimatedSkeleton()
        walkButton.showAnimatedSkeleton()
        pickerLines.showAnimatedSkeleton()
        timeLabel.showAnimatedSkeleton()
        timeRoadLabel.showAnimatedSkeleton()
        distanceLabel.showAnimatedSkeleton()
        turnButton.showAnimatedSkeleton()
        timeIcon.showAnimatedSkeleton()
        timeRoadIcon.showAnimatedSkeleton()
        distanceIcon.showAnimatedSkeleton()
        lineInstruct.showAnimatedSkeleton()
    }
    
    func hideSkeletonView() {
        storeImageView.hideSkeleton()
        storeNameLabel.hideSkeleton()
        storeAddressLabel.hideSkeleton()
        mapView.hideSkeleton()
        mapView.isHidden = false
        carButton.hideSkeleton()
        motorbikeButton.hideSkeleton()
        walkButton.hideSkeleton()
        pickerLines.hideSkeleton()
        timeLabel.hideSkeleton()
        timeRoadLabel.hideSkeleton()
        distanceLabel.hideSkeleton()
        turnButton.hideSkeleton()
        timeIcon.hideSkeleton()
        timeRoadIcon.hideSkeleton()
        distanceIcon.hideSkeleton()
        lineInstruct.hideSkeleton()
    }
    
    func setupView() {
        hideSkeletonView()
        storeImageView.image = UIImage(named: "Banks")
        storeNameLabel.text = stores.storeDetail?.name
        storeAddressLabel.text = stores.storeDetail?.storeAddress?.street
        storeImageView.layer.cornerRadius = storeImageView.frame.size.width / 2
        storeImageView.layer.borderWidth = 3.0
        storeImageView.borderColor = kColorButtonActive
        storeImageView.clipsToBounds = true
        carButton.isSelected = true
        motorbikeButton.isSelected = false
        walkButton.isSelected = false
    }
    
    func loadAddress() {
        let placeData = UserDefaults.standard.data(forKey: "address")
        let placeArray = try! JSONDecoder().decode([AddressUser].self, from: placeData!)
    }
    
    func loadShifts() {
        let shift = UserDefaults.standard.data(forKey: "Shifts")
        if shift != nil {
            let shiftHist = try! JSONDecoder().decode([ShiftsHistory].self, from: shift!)
            self.shifts = shiftHist
        }
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
    
    func drawRoute(_ id: Int) {
        let sourceLocation = CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
        let destinationLocation = CLLocationCoordinate2D(latitude: self.storeLat, longitude: self.storeLong)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        switch id {
        case 0:
            directionRequest.transportType = .automobile
        case 1:
            directionRequest.transportType = .automobile
        case 2:
            directionRequest.transportType = .walking
        default:
            break
        }
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            let distance = route.distance
            let eta = route.expectedTravelTime
            
            self.distanceLabel.text = String(format: "%.2f Km", distance.inKilometers())
            self.timeRoadLabel.text = self.stringFromTimeInterval(interval: eta)
            self.timeLabel.text = self.getTimeShift()
            
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func putMarkers() {
        let sourceAnnotation = MKPointAnnotation()
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        sourceAnnotation.title = "Times Square"
        sourceAnnotation.coordinate.latitude = (userLocation?.coordinate.latitude)!
        sourceAnnotation.coordinate.longitude = (userLocation?.coordinate.longitude)!
        destinationAnnotation.coordinate.latitude = storeLat
        destinationAnnotation.coordinate.longitude = storeLong
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        hourShift = hours
        minutesShift = minutes
        
        if hours != 0 {
            return String(format: "%0.1d hrs", hours)
        }else if minutes != 0 {
            return String(format: "%0.1d min", minutes)
        }else if seconds != 0 {
            return String(format: "%0.1d s", seconds)
        }else if seconds == 0 {
            return "now"
        }else {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }
    
    func getTimeShift() -> String {
        let date = Date()
        let calendar = Calendar.current
        var time = calendar.date(byAdding: .hour, value: hourShift, to: Date())
        time = calendar.date(byAdding: .minute, value: minutesShift, to: time!)
        time = calendar.date(byAdding: .minute, value: 5, to: time!)
        
        let thour = calendar.component(.hour, from: time!)
        let tminutes = calendar.component(.minute, from: time!)

        //let thour = hour + hourShift
        //let tminutes = minutes + minutesShift + 5
        return String(format: "%0.2d:%0.2d", thour, tminutes)
    }
    
    func showAlertImageZoom(images: [UIImage]) {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "ImageZoomViewController") as! ImageZoomViewController
        customAlert.imagess = self.images
        self.view.addSubview(customAlert.view)
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
        }
    }
    
    /*func getShiftUser() {
        let phone = AppInfo().phone
        let line = self.lineSelected.id
        let minutes = self.minutesShift
        APIVirtualLines.getUserShift(storeId: storeId, phone: phone, line: line, minutes: minutes).debug("APIVirtualLines.getShiftUser").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.shift = dataResponse
            self.loadShifts()
            self.saveShifts()
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
    }*/
    
    func saveShifts() {
        var placesArray: [ShiftsHistory] = []
        let id = stores.storeDetail?.id
        let name = stores.storeDetail?.name
        let add = stores.storeDetail?.storeAddress?.street
        let cat = stores.storeDetail?.storeCategoryId
        let shi = self.shift.shift?.shift
        placesArray.append(ShiftsHistory(idStore: id!, latitude: lat, longitude: lon, nameStore: name!, addresStore: add!, category: cat!, shift: shi!))
        let placesData = try! JSONEncoder().encode(placesArray)
        UserDefaults.standard.set(placesData, forKey: "Shifts")
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
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        self.images.append(UIImage(named: "Banks")!)
        showAlertImageZoom(images: self.images)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        if flagWalk {
            renderer.lineDashPattern = [0, 10]
        }
        return renderer
    }
    
    // MARK: - MapViewDelegate
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        if !mapIsLoaded {
            mapIsLoaded = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idle")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("WillMove")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        /*self.centerMapOnLocation(coordinate: marker.position, zoom: 16, isUserPosition: false)
         collapsedDrawer()
         self.uiComponentIsSelected = true*/
        return true
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        //self.mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        self.userLocation = locations.first!
        //self.centerMapOnLocation(coordinate: (self.userLocation?.coordinate)!, zoom: 10, isUserPosition: true)
        putMarkers()
        self.lat = (self.userLocation?.coordinate.latitude)!
        self.lon = (self.userLocation?.coordinate.longitude)!
        putMarkers()
        drawRoute(0)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("error")
    }
    
    /*func centerMapOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        if isUserPosition {
            let newCoordinate =  CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude) //-0,025
            mapView.animate(to: GMSCameraPosition(target: newCoordinate, zoom: 16, bearing: 0, viewingAngle: 0))
        } else {
            mapView.animate(to: GMSCameraPosition(target: coordinate, zoom: zoom, bearing: 0, viewingAngle: 0))
        }
        mapView.isMyLocationEnabled = true
    }*/
    
    @IBAction func automobilePressed() {
        self.mapView.removeOverlays(self.mapView.overlays)
        carButton.isSelected = true
        motorbikeButton.isSelected = false
        walkButton.isSelected = false
        flagWalk = false
        drawRoute(0)
    }
    
    @IBAction func motorbikePressed() {
        self.mapView.removeOverlays(self.mapView.overlays)
        carButton.isSelected = false
        motorbikeButton.isSelected = true
        walkButton.isSelected = false
        flagWalk = false
        drawRoute(1)
    }
    
    @IBAction func walkingPressed() {
        self.mapView.removeOverlays(self.mapView.overlays)
        carButton.isSelected = false
        motorbikeButton.isSelected = false
        walkButton.isSelected = true
        flagWalk = true
        drawRoute(2)
    }
    
    @IBAction func buttonNextPressed() {
        //getShiftUser()
    }
    
}

extension ShiftInformationViewController : PickerVirtualLinesDelegate {
    func didSelect(_ sender: PickerVirtualLines, index: Int) {
        if sender == self.pickerLines {
            self.lineSelected = (lin?[index])!
        }
    }
}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
