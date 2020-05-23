//
//  MapShiftViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 7/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import RxSwift

class MapShiftViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var timeRoad: UILabel!
    @IBOutlet weak var distanceRoad: UILabel!
    @IBOutlet weak var motorView: UIView!
    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var walkView: UIView!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var motorButton: UIButton!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var errorRoad: UIView!
    
    var lat: Double = 0
    var lon: Double = 0
    var storeLat: Double = 0
    var storeLong: Double = 0
    var storeId: Int = 0
    
    var modeTransport: String = ""
    var number = AppInfo().phone
    
    var stores: DataStore = DataStore()
    var route: Routes = Routes()
    var road: Directions = Directions()
    var timeArrival: TimeArrival = TimeArrival()
    var time: DirectionsTime = DirectionsTime()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        lat = AppInfo().userLat
        lon = AppInfo().userLong
        modeTransport = "driving"
        activeButton(button: 1)
        mapView.delegate = self
        self.setupMap()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        self.getParameters()
        self.getParametersTime()
    }*/
    
    func locateMap() {
        storeLat = (stores.storeDetail?.storeAddress!.lat)!
        storeLong = (stores.storeDetail?.storeAddress!.lng)!
        storeId = stores.storeDetail!.id
        self.getParameters()
        self.getParametersTime()
        zoomMap()
    }
    
    func zoomMap() {
        let path = GMSMutablePath()
        
        //for each point you need, add it to your path
        let position = CLLocationCoordinate2DMake(storeLat, storeLong)
        path.add(position)
        let positionUs = CLLocationCoordinate2DMake(lat, lon)
        path.add(positionUs)
        
        //Update your mapView with path
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
        mapView.moveCamera(cameraUpdate)
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
    }
    
    func setupRoad() {
        for poly in road.data!.route1 {
            drawPath(from: poly)
        }
        revealedDrawer()
    }
    
    func setupError() {
        errorRoad.isHidden = false
    }
    
    func setupTime() {
        timeRoad.text = self.time.data[0].duration
        distanceRoad.text = self.time.data[0].distance
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
    
    func revealedDrawer() {
        let master = parent as! PreviewShiftViewController
        master.pulleyRevealed()
    }
    
    func collapsedDrawer() {
        let master = parent as! PreviewShiftViewController
        master.pulleyCollapsed()
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
    
    func getRoutes() {
        APIVirtualLines.getRoutes(body: route, number: number).debug("APIVirtualLines.GetRoutes").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.road = dataResponse
            self.setupRoad()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getRoutes()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
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
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func activeButton(button: Int) {
        switch button {
        case 1:
            carView.backgroundColor = kColorButtonActive
            motorView.backgroundColor = .white
            walkView.backgroundColor = .white
            let image = resizeImage(image: UIImage(named: "Car")!, targetSize: CGSize(width: 30, height: 30))
            carButton.setImage(image.tinted(with: .white), for: .normal)
            let image2 = resizeImage(image: UIImage(named: "MotorBike")!, targetSize: CGSize(width: 30, height: 30))
            motorButton.setImage(image2, for: .normal)
            let image3 = resizeImage(image: UIImage(named: "Walk")!, targetSize: CGSize(width: 30, height: 30))
            walkButton.setImage(image3, for: .normal)
        case 2:
            carView.backgroundColor = .white
            motorView.backgroundColor = kColorButtonActive
            walkView.backgroundColor = .white
            let image = resizeImage(image: UIImage(named: "Car")!, targetSize: CGSize(width: 30, height: 30))
            carButton.setImage(image, for: .normal)
            let image2 = resizeImage(image: UIImage(named: "MotorBike")!, targetSize: CGSize(width: 30, height: 30))
            motorButton.setImage(image2.tinted(with: .white), for: .normal)
            let image3 = resizeImage(image: UIImage(named: "Walk")!, targetSize: CGSize(width: 30, height: 30))
            walkButton.setImage(image3, for: .normal)
        case 3:
            carView.backgroundColor = .white
            motorView.backgroundColor = .white
            walkView.backgroundColor = kColorButtonActive
            let image = resizeImage(image: UIImage(named: "Car")!, targetSize: CGSize(width: 30, height: 30))
            carButton.setImage(image, for: .normal)
            let image2 = resizeImage(image: UIImage(named: "MotorBike")!, targetSize: CGSize(width: 30, height: 30))
            motorButton.setImage(image2, for: .normal)
            let image3 = resizeImage(image: UIImage(named: "Walk")!, targetSize: CGSize(width: 30, height: 30))
            walkButton.setImage(image3.tinted(with: .white), for: .normal)
        default:
            break
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idle")
        revealedDrawer()
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        collapsedDrawer()
    }
    
    @IBAction func carButtonPressed() {
        modeTransport = "driving"
        activeButton(button: 1)
        getParametersTime()
        getParameters()
    }
    
    @IBAction func bicycleButtonPressed() {
        modeTransport = "bicycling"
        activeButton(button: 2)
        getParametersTime()
        getParameters()
    }
    
    @IBAction func walkingButtonPressed() {
        modeTransport = "walking"
        activeButton(button: 3)
        getParametersTime()
        getParameters()
    }
}
