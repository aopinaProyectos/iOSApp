//
//  AddressPopView3.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/10/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class AddressPopView3: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var currentLocation: CLLocation?
    var mapIsLoaded: Bool = false
    var comeFromautocomplete = false
    var latSearch: Double = 0
    var lonSearch: Double = 0
    var lat: Double = 0
    var lon: Double = 0
    var street = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cord = CLLocationCoordinate2D()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        if comeFromautocomplete {
            cord.latitude = latSearch
            cord.longitude = lonSearch
            self.centerMapOnLocation(coordinate: cord, zoom: 10, isUserPosition: true)
        }
    }
    
    
    
    @IBAction func savePressed(){
        AppInfo().userLat = lat
        AppInfo().userLong = lon
        geocodingInverse(lat: lat, lon: lon)
    }
    
    
    // MARK: - MapViewDelegate
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        if !mapIsLoaded {
            mapIsLoaded = true
        }
        lat = self.mapView.camera.target.latitude
        lon = self.mapView.camera.target.longitude
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idle")
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        lat = self.mapView.camera.target.latitude
        lon = self.mapView.camera.target.longitude
        
        print("WillMove")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
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
        if !comeFromautocomplete {
            self.centerMapOnLocation(coordinate: (self.userLocation?.coordinate)!, zoom: 16, isUserPosition: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("error")
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 20.0)
        self.mapView.camera = camera
        /*if isUserPosition {
            let newCoordinate =  CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude) 
            mapView.animate(to: GMSCameraPosition(target: newCoordinate, zoom: 16, bearing: 0, viewingAngle: 0))
        } else {
            mapView.animate(to: GMSCameraPosition(target: coordinate, zoom: zoom, bearing: 0, viewingAngle: 0))
        }
        mapView.isMyLocationEnabled = true*/
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
                    
                    if pm.subLocality != nil {
                        self.street = pm.subLocality!
                    }
                    if pm.thoroughfare != nil {
                        self.street = self.street + " " + pm.thoroughfare!
                    }
                    AppInfo().addressStreet = self.street
                    AppInfo().addressLat = self.lat
                    AppInfo().addressLon = self.lon
                    AppInfo().addressAlert = true
                    self.dismiss(animated: true, completion: nil)
                }
        })
    }
}
