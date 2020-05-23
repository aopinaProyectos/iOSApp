//
//  ShiftMapViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/20/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import RxSwift
import Pulley

class ShiftMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var currentLocation: CLLocation?
    var category: Int = 0
    var lat: Double = 0
    var lon: Double = 0
    var mapIsLoaded: Bool = false
    var uiComponentIsSelected: Bool = false
    var handlerPulley: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        handlerPulley()
    }
    
    func collapsedDrawer() {
        let master = parent as! GetShiftViewController
        master.pulleyCollapsed()
    }
    
    func revealedDrawer() {
        let master = parent as! GetShiftViewController
        master.pulleyRevealed()
    }
    
    func sendCoordinates() {
        let master = parent as! GetShiftViewController
        master.lat = self.lat
        master.lon = self.lon
    }
    
    // MARK: - MapViewDelegate
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        if !mapIsLoaded {
            mapIsLoaded = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idle")
        revealedDrawer()
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        lat = self.mapView.camera.target.latitude
        lon = self.mapView.camera.target.longitude
        sendCoordinates()
        collapsedDrawer()
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
        self.mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        self.userLocation = locations.first!
        self.centerMapOnLocation(coordinate: (self.userLocation?.coordinate)!, zoom: 16, isUserPosition: true)
        self.lat = (self.userLocation?.coordinate.latitude)!
        self.lon = (self.userLocation?.coordinate.longitude)!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("error")
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        if isUserPosition {
            let newCoordinate =  CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude) //-0,025
            mapView.animate(to: GMSCameraPosition(target: newCoordinate, zoom: 16, bearing: 0, viewingAngle: 0))
        } else {
            mapView.animate(to: GMSCameraPosition(target: coordinate, zoom: zoom, bearing: 0, viewingAngle: 0))
        }
        mapView.isMyLocationEnabled = true
    }
    
    func centerMapOnLocationMarker(coordinate: CLLocationCoordinate2D, zoom: Float, isUserPosition: Bool) {
        self.mapView?.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16)
    }
    
    
}
