//
//  MapStoreGMapViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/26/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import Pulley

protocol ContainerToMaster {
    func printText(text:String)
}

class MapStoreGmapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var detailPlaces: UIView!
    @IBOutlet weak var titleDetail: UILabel!
    @IBOutlet weak var distanceDetail: UILabel!
    
    
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var currentLocation: CLLocation?
    var category: Int = 0
    var lat: Double = 0
    var lon: Double = 0
    var mapIsLoaded: Bool = false
    var uiComponentIsSelected: Bool = false
    var selectedStore: DataStore?
    var mapMarkers : [GMSMarker] = []
    
    var tablesViewController: UIViewController?
    
    var handlerGotData : ([DataStore]) -> () = { _ in }
    var callback: ((_ id: Int) -> Void)?
    
    //var handlerGotData : (String, CLLocation, [DataStore]) -> () = { _  in }
    var handlerPulley: () -> () = {}
    var completionHandler: ((String) -> Int)?
    
    var firstVC = MapStoreTableViewController()
    var containerToMaster:ContainerToMaster?
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        category = AppInfo().category
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        
        let storyboard = UIStoryboard(name: "Stores", bundle: nil)
        tablesViewController = storyboard.instantiateViewController(withIdentifier: "DrawerContentViewController") as! MapStoreTableViewController
        handlerPulley()
        
    }
    
    func setupDetailAnnotation() {
        if let store = self.selectedStore {
            titleDetail.text = store.storeDetail?.name ?? ""
            if let location = self.userLocation {
                distanceDetail.text = String(format: "%.1f Km", location.distance(from: CLLocation(latitude: (store.storeDetail?.storeAddress!.lat)!, longitude: (store.storeDetail?.storeAddress!.lng)!)).rounded() / 1000)
            } else {
                distanceDetail.text = String(format: "%.1f Km", userLocation!.distance(from: CLLocation(latitude: (store.storeDetail?.storeAddress!.lat)!, longitude: (store.storeDetail?.storeAddress!.lng)!)).rounded() / 1000)
            }
        }
        self.detailPlaces.isHidden = false
        self.searchButton.isHidden = true
    }
    
    func getNearPlaces() {
        let parameters = createBody()
        let body = ["location":parameters]
        APIVirtualLines.getNearPlaces(body: body, category: category).debug("APIVirtualLines.NearPlaces").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.setPlaces(stores: dataResponse.places!)
            self.passDataDrawer(stores: dataResponse.places!)
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["lat"] = lat
        bodyCollection["lng"] = lon
        return bodyCollection
    }
    
    func setPlaces(stores: [DataStore]) {
        if stores.count > 0 {
            self.removeAllMarkers()
        }else {
            return
        }
        let fixedPlaceIcon = UIImage(named:"Pin")
        let pin = resizeImage(image: fixedPlaceIcon!, targetSize: CGSize(width: 30, height: 30))
        
        for store in stores {
            let position = CLLocationCoordinate2D(latitude: (store.storeDetail?.storeAddress!.lat)!, longitude: (store.storeDetail?.storeAddress!.lng)!)
            let marker = GMSMarker(position: position)
            marker.title = store.storeDetail?.name
            marker.userData = store
            marker.icon = pin
            marker.map = self.mapView
            mapMarkers.append(marker)
        }
        self.searchButton.isHidden = true
        
    }
    
    func passDataDrawer(stores: [DataStore]) {
        let master = parent as! MapStoreViewController
        master.stores = stores
        master.reloadTableView()
    }
    
    func getTurn() {
        let master = parent as! MapStoreViewController
        master.selectedStore = selectedStore
        master.shiftPressed()
    }
    
    func collapsedDrawer() {
        let master = parent as! MapStoreViewController
        master.pulleyCollapsed()
    }
    
    func selectMarker() {
        //centerMapOnLocation(coordinate: mapMarkers[1].position, zoom: 16, isUserPosition: false)
        for mark in mapMarkers {
            if mark.title == selectedStore?.storeDetail?.name {
                self.centerMapOnLocationPressed(coordinate: mark.position, zoom: 18.0)
                self.setupDetailAnnotation()
                //self.mapView.selectedMarker = mark
            }
        }
    }
    
    private func removeAllMarkers() {
        self.mapView.clear()
    }
    
    @IBAction func locateUser(_ sender: Any) {
        locationManager.startUpdatingLocation()
        self.centerMapOnLocation(coordinate: (self.userLocation?.coordinate)!, zoom: 16, isUserPosition: true)
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        lat = self.mapView.camera.target.latitude
        lon = self.mapView.camera.target.longitude
        self.getNearPlaces()
    }
    
    @IBAction func getTurnPressed() {
        getTurn()
    }
    
    
    // Mark: Google Maps
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        if !mapIsLoaded {
            mapIsLoaded = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if mapIsLoaded && !uiComponentIsSelected {
            collapsedDrawer()
        }
        self.uiComponentIsSelected = false
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        lat = self.mapView.camera.target.latitude
        lon = self.mapView.camera.target.longitude
        if !uiComponentIsSelected {
            collapsedDrawer()
            self.detailPlaces.isHidden = true
            self.searchButton.isHidden = false
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.detailPlaces.isHidden = true
        self.searchButton.isHidden = true
        self.selectedStore = marker.userData as! DataStore
        self.centerMapOnLocationPressed(coordinate: marker.position, zoom: 18.0)
        setupDetailAnnotation()
        collapsedDrawer()
        self.uiComponentIsSelected = true
        return true
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        self.mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        self.userLocation = locations.first!
        self.centerMapOnLocation(coordinate: (self.userLocation?.coordinate)!, zoom: 16, isUserPosition: true)
        self.lat = (self.userLocation?.coordinate.latitude)!
        self.lon = (self.userLocation?.coordinate.longitude)!
        self.getNearPlaces()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("error")
    }
    
    func centerMapOnLocationPressed(coordinate: CLLocationCoordinate2D, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoom)
        self.mapView.camera = camera
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        if isUserPosition {
            let newCoordinate =  CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude) //-0,025
            mapView.animate(to: GMSCameraPosition(target: newCoordinate, zoom: 16, bearing: 0, viewingAngle: 0))
            getNearPlaces()
        } else {
            mapView.animate(to: GMSCameraPosition(target: coordinate, zoom: zoom, bearing: 0, viewingAngle: 0))
        }
        mapView.isMyLocationEnabled = true
    }
    
    func centerMapOnLocationMarker(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        self.mapView?.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16)
    }


}
