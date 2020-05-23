//
//  SearchTableViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/30/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift

class SearchTableViewController: CustomTabBarViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating, CLLocationManagerDelegate, UISearchControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var lat: Double = 0
    var long: Double = 0
    var cat: Int = 0
    
    var arrayFilter = [DataStore]()
    var lasthistory = 0
    var flagLoc = true
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    var stores: [DataStore] = []
    
    let locationManager = CLLocationManager()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLocation()
        self.showTabBar()
        self.setOpaqueNavigationBar()
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.searchController.searchResultsUpdater = self
        //self.searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
        self.resultsController.tableView.tableFooterView = UIView()
        self.resultsController.tableView.tableHeaderView = UIView()
        tableView.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.creatingSearchBar()
        self.tableSettings()
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
    
    func creatingSearchBar() {
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    func tableSettings() {
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
    }
    
    func getPlacesByName(category: Int) {
        let parameters = createBody()
        let body = ["location":parameters]
        APIVirtualLines.getNearPlaces(body: body, category: category).debug("APIVirtualLines.GetPlacesByName").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.bigDatabase(store: dataResponse.places!, category: category)
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func bigDatabase(store: [DataStore], category: Int) {
        for place in store {
            self.stores.append(place)
        }
        if category != 6 {
            self.cat = category + 1
            getPlacesByName(category: self.cat)
        }
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["lat"] = lat
        bodyCollection["lng"] = long
        return bodyCollection
    }
    
//    MARK: Resultupdating
    func updateSearchResults(for searchController: UISearchController) {
        let textToSearch = self.searchController.searchBar.text!.lowercased()
        findStore(store: self.stores, search: textToSearch)
        self.resultsController.tableView.reloadData()
    }
    
    func findStore(store: [DataStore], search: String) {
        self.arrayFilter = []
        for place in store {
            if (place.storeDetail?.name.lowercased().contains(search.lowercased()))! {
                self.arrayFilter.append(place)
            }
        }
    }
    
//    Mark Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = locValue.latitude
        long = locValue.longitude
        locationManager.stopUpdatingLocation()
        if flagLoc {
            self.getPlacesByName(category: 1)
            flagLoc = false
        }
    }
    
//    MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return 2
            default:
                break
            }
        }
        return arrayFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(UINib(nibName: kRecomendationsCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kRecomendationsCellReuseIdentifier)
        self.tableView.register(UINib(nibName: kFeaturesCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kFeaturesCellReuseIdentifier)
        self.tableView.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        self.tableView.register(UINib(nibName: kSearchHistoryCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kSearchHistoryCellReuseIdentifier)
        self.tableView.register(UINib(nibName: kButtonHistoryCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kButtonHistoryCellReuseIdentifier)
        self.resultsController.tableView.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        if tableView == self.tableView {
            if indexPath.row == 0 && indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "recomendationsCell", for: indexPath)
                return cell
            }else if indexPath.row == 0 && indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "featuresCell", for: indexPath)
                return cell
            }else if indexPath.row == lasthistory && indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonHistoryCell", for: indexPath)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath)
                return cell
            }
        }else if tableView == self.resultsController.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataStoreCell", for: indexPath) as! dataStoreCell
            cell.setupView(name: self.arrayFilter[indexPath.row].storeDetail!.name, address: (self.arrayFilter[indexPath.row].storeDetail?.storeAddress!.street)!, category: self.arrayFilter[indexPath.row].storeDetail!.storeCategoryId )
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataStoreCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView {
            self.tableView.register(UINib(nibName: kStoreHeaderCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kStoreHeaderCellReuseIdentifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: "storeHeaderCell") as! storeHeaderCell
            if section == 0 {
                cell.setupView(title: "Recomendados")
            }else if section == 1 {
                cell.setupView(title: "Lo mas buscado")
            } else {
                cell.setupView(title: "Historial de Busqueda")
            }
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.resultsController.tableView {
            return section == 0 ? 1.0 : 20
        }
        return 20
    }
    
//    Mark: SearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}
