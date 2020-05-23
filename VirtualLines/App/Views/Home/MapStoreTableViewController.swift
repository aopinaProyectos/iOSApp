//
//  MapStoreTableViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/26/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import UIKit
import Pulley
import UIKit
import MapKit
import RxSwift

class MapStoreTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stores : [DataStore]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    let locationManager = CLLocationManager()
    var handlerSelectedStore : (DataStore) -> () = { _ in }
    var handlerPulley: () -> () = {}
    var userLocation : CLLocation?
    var selectStore: DataStore?
    
    var lat: Double = 0
    var long: Double = 0
    var category: Int = 0
    
    var storesArray: [DataStore] = []
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLocation()
        self.getNearPlaces()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView?.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        let vc = MapStoreGmapViewController()
        vc.completionHandler = { text in
            print("text = \(text)")
            return text.count
        }
        
        
    }
    
    func initLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getNearPlaces() {
        category = AppInfo().category
        let parameters = createBody()
        let body = ["location":parameters]
        APIVirtualLines.getNearPlaces(body: body, category: category).debug("APIVirtualLines.NearPlaces").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.storesArray = dataResponse.places!
            self.tableView.reloadData()
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func printData() {
        print ("Hola mundo ----------->")
        self.tableView.reloadData()
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["lat"] = lat
        bodyCollection["lng"] = long
        return bodyCollection
    }
    
    func reloadDataTable() {
        self.tableView.reloadData()
        partiallyDrawer()
    }
    
    func partiallyDrawer() {
        let master = parent as! MapStoreViewController
        master.pulleyRevealed()
    }
    
    func selectStoreCell() {
        let master = parent as! MapStoreViewController
        master.selectedStore = selectStore
        master.selectStore()
    }
    
    
    
    //    Mark Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = locValue.latitude
        long = locValue.longitude
        locationManager.stopUpdatingLocation()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.stores?.count ?? 0
        return storesArray.count
        //return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataStoreCell") as! dataStoreCell
        cellDefault.hideAnimation()
        cellDefault.setupViewCell(store: self.storesArray[indexPath.row])
    //cellDefault.setupView(name: self.storesArray[indexPath.row].storeDetail!.name, address: (self.storesArray[indexPath.row].storeDetail?.storeAddress!.street)!, category: self.storesArray[indexPath.row].storeDetail!.storeCategoryId)
        cellDefault.selectionStyle = .none
        return cellDefault
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectStore = storesArray[indexPath.row]
        self.selectStoreCell()
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }*/
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension MapStoreTableViewController: PulleyDrawerViewControllerDelegate {
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 50.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 400.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    
    /*func collapsedDrawerHeight() -> CGFloat {
        return 100.0 //65
    }
    
    func partialRevealDrawerHeight() -> CGFloat {
        return 400.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }*/
}
