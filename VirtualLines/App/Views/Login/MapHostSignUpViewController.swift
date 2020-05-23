//
//  MapHostSignUpViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

class MapHostSignUpViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var mapViews: GMSMapView!
    @IBOutlet weak var userLocationAnnotation: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var backgroundImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var balloonAddress: UIView!
    
    var userLocation : CLLocation?
    var locationManager = CLLocationManager()
    var resultView: UITextView?
    var searchController: UISearchController?
    var storeProfile: StoreProfile = StoreProfile()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var address: String = ""
    var street: String = ""
    var nameStore: String = ""
    var categ: Int = 0
    
    var comeFromMenu = false
    var mapIsLoaded = false
    var lat: Double = 0
    var long: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.mapViews.delegate = self
        
        self.resultsViewController = GMSAutocompleteResultsViewController()
        self.resultsViewController?.delegate = self
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Busca tu negocio"
        self.navigationItem.titleView = searchController?.searchBar
        
        self.definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        
        storeName.isHidden = true
        storeAddress.isHidden = true
        
        nextButton.isEnabled = true
        nextButton.backgroundColor = #colorLiteral(red: 0.3111690581, green: 0.5590575933, blue: 0.8019174337, alpha: 1)
        
        if comeFromMenu {
            self.tabBarController?.tabBar.isHidden = true
            setTitleChild("Se un Host Paso 1 de 3")
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openRegisterDataHost.rawValue {
            let viewController = segue.destination as! RegisterDataHostViewController
            viewController.storeProfile = storeProfile
        }
    }
    
    func getLocations() -> CLLocationCoordinate2D {
        var currentLocation = CLLocationCoordinate2D()
        currentLocation.latitude = self.mapViews.camera.target.latitude
        currentLocation.longitude = self.mapViews.camera.target.longitude
        return currentLocation
    }
    
    func getData() {
        var cordinates = CLLocationCoordinate2D()
        let lat = self.mapViews.camera.target.latitude
        let lon = self.mapViews.camera.target.longitude
        storeProfile.store.storeAddress.lat = self.mapViews.camera.target.latitude
        storeProfile.store.storeAddress.lng = self.mapViews.camera.target.longitude
        cordinates.latitude = lat
        cordinates.longitude = lon
        reverseGeocodeCoordinate(coordinate: cordinates)
    }
    
    func setupBallon() {
        backgroundImage.backgroundColor = kColorButtonActive
        backgroundImage.cornerRadius = backgroundImage.frame.height / 2
        storeName.text = storeProfile.store.name
        storeAddress.text = self.street
        storeAddress.isHidden = false
        storeName.isHidden = false
        switch storeProfile.store.storeCategoryId {
        case 1:
            imageView.image = UIImage(named: "Banks")
        case 2:
            imageView.image = UIImage(named: "Restaurants")
        case 3:
            imageView.image = UIImage(named: "Enterteinment")
        case 4:
            imageView.image = UIImage(named: "Health")
        case 5:
            imageView.image = UIImage(named: "Education")
        case 6:
            imageView.image = UIImage(named: "Pets")
        default:
            print("Descargar imagen de internet")
            
        }
    }
    
    // Mark: Google Maps
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        print ("FinishLoad")
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        lat = self.mapViews.camera.target.latitude
        long = self.mapViews.camera.target.longitude
        geocodingInverse(lat: lat, lon: long)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.balloonAddress.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.centerMapOnLocation(coordinate: marker.position, zoom: 16, isUserPosition: false)
        return true
    }
    
    
//    Map Location Manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        self.mapViews.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.first!
        self.centerMapOnLocation(coordinate: (self.userLocation?.coordinate)!, zoom: 16, isUserPosition: true)
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("error")
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 20.0)
        self.mapViews.camera = camera
        /*if isUserPosition {
            let newCoordinate =  CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude) //-0,025
            mapViews.animate(to: GMSCameraPosition(target: newCoordinate, zoom: 16, bearing: 0, viewingAngle: 0))
        } else {
            mapViews.animate(to: GMSCameraPosition(target: coordinate, zoom: zoom, bearing: 0, viewingAngle: 0))
        }
        mapViews.isMyLocationEnabled = true*/
    }
    
    private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        var add = ""
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines, let extNum = address.thoroughfare, let municipality = address.subLocality, let state = address.administrativeArea, let country = address.country, let zipCode = address.postalCode else {
                return
            }
            add = lines.joined(separator: "\n")
            self.street = add
            self.storeProfile.store.storeAddress.street = add
            self.storeProfile.store.storeAddress.extNum = extNum
            self.storeProfile.store.storeAddress.municipality = municipality
            self.storeProfile.store.storeAddress.state = state
            self.storeProfile.store.storeAddress.country = country
            self.storeProfile.store.storeAddress.zipCode = zipCode
        }
        self.setupBallon()
        self.balloonAddress.isHidden = false
    }
    
    private func geocodingInverse(lat:Double, lon:Double){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                //Tenemos que corregir el problema con los nil
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.thoroughfare)
                    print(pm.subLocality)
                    print(pm.locality)
                    print(pm.country)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
            
                    if pm.thoroughfare != nil {
                        self.storeProfile.store.storeAddress.street = pm.thoroughfare!
                        self.street = pm.thoroughfare!
                    }
                    if pm.subThoroughfare != nil {
                        self.storeProfile.store.storeAddress.extNum = pm.subThoroughfare!
                        self.street = self.street + " " + pm.subThoroughfare!
                    }
                    if pm.subLocality != nil {
                        self.storeProfile.store.storeAddress.municipality = pm.subLocality!
                        self.street = self.street + " " + pm.subLocality!
                    }
                    if pm.locality != nil {
                        self.storeProfile.store.storeAddress.state = pm.locality!
                    }
                    if pm.country != nil {
                        self.storeProfile.store.storeAddress.country = pm.country!
                    }
                    if pm.postalCode != nil {
                        self.storeProfile.store.storeAddress.zipCode = pm.postalCode!
                    }
                }
                self.storeProfile.store.storeAddress.street = self.street
                self.setupBallon()
                self.balloonAddress.isHidden = false
        })
    }
    
    // GMSAutocomplete Delegate
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        self.centerMapOnLocation(coordinate: place.coordinate, zoom: 16, isUserPosition: true)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @IBAction func locateUser(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                locationManager.startUpdatingLocation()
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                self.centerMapOnLocation(coordinate: (self.userLocation?.coordinate)!, zoom: 20, isUserPosition: false)
            }
        } else {
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func nextView(_ sender: Any) {
        getData()
        self.performSegue(withIdentifier: SeguesIdentifiers.openRegisterDataHost.rawValue, sender: self)
    }
    
}


extension MapHostSignUpViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController!,
                           didAutocompleteWithPlace place: GMSPlace!) {
        searchController?.isActive = false
        // Do something with the selected place.
    }

    func resultsController(resultsController: GMSAutocompleteResultsViewController!,
                           didFailAutocompleteWithError error: NSError!){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}





