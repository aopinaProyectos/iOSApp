//
//  LocationService.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Service that supports device localization
 */
class LocationService {
    
    /**
     Function that gives permission to use geolocation
     - returns: void
     - parameter locationManager: service object
     - parameter delegate: Protocol with the necessary services for the location
     - parameter mayStartUpdating: Flag that says if you start counting the location, default false
     */
    class func authorizationLocation(locationManager: CLLocationManager, delegate: CLLocationManagerDelegate? = nil, mayStartUpdating: Bool = false) {
        
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 50
        locationManager.requestWhenInUseAuthorization()
        
        if let _ = locationManager.delegate, mayStartUpdating{
            locationManager.startUpdatingLocation()
        }
    }
}
