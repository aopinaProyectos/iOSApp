//
//  FavoritesViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/7/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, cellFavoriteDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var flagError: Bool = false
    var flagEmptyTable: Bool = false
    var cellRemove: Int = 0
    var categoryFrequent: Int = 0
    var countFrequent: Int = 1
    var favoritesPlaces: [DataStore] = [DataStore]()
    var storeSelected: DataStore = DataStore()
    var frequentResponse: [DataStore] = [DataStore]()
    var frequentPlaces: [DataStore] = [DataStore]()
    var placeFavorite: Favorites = Favorites()
    
    let phone = AppInfo().phone
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.setOpaqueNavigationBar()
        self.setTitleChild("Mis Favoritos")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = #colorLiteral(red: 0.9715679288, green: 0.9767023921, blue: 0.9850376248, alpha: 1)
        tableView?.register(UINib(nibName: kFavoriteCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kFavoriteCellReuseIdentifier)
        tableView?.register(UINib(nibName: kEmptyFavoriteCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kEmptyFavoriteCellReuseIdentifier)
        tableView?.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        tableView.separatorStyle = .none
        //getFavoritesPlaces(phone: phone)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        getFavoritesPlaces(phone: phone)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openShiftInformation.rawValue {
            let nextViewController = segue.destination as! PreviewShiftViewController
            nextViewController.stores = self.storeSelected
        }else {
            let nextViewController = segue.destination as! ShiftPreviewViewController
            nextViewController.stores = self.storeSelected
        }
    }
    
    func frequentProcess() {
        for i in 1...6 {
            categoryFrequent = i
            getFrequentPlaces()
        }
    }
    
    func getFrequentPlaces() {
        APIVirtualLines.getFrequentPlaces(category: categoryFrequent).debug("APIVirtualLines.getFrequentPlaces").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.frequentResponse = dataResponse.places!
            for place in self.frequentResponse {
                self.frequentPlaces.append(place)
            }
            self.tableView.reloadData()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getFrequentPlaces()
            case CatalogError.NoLinesFound(let response):
                self.showAlertError(id: 2, text: response.message)
                self.flagError = true
            case NetworkingError.Timeout:
                self.showAlertError(id: 0, text: "")
            case NetworkingError.NoInternet:
                self.showAlertError(id: 1, text: "")
            case CatalogError.NotFoundPlaces:
                self.tableView.reloadData()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    
    
    func getFavoritesPlaces(phone: String) {
        countFrequent = 0
        APIVirtualLines.getFavoritesPlaces(number: phone).debug("APIVirtualLines.getFavoritesPlaces").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.favoritesPlaces = dataResponse.places!
            self.frequentProcess()
            //self.tableView.reloadData()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getFavoritesPlaces(phone: phone)
            case CatalogError.NoLinesFound(let response):
                self.showAlertError(id: 2, text: response.message)
                self.flagError = true
            case NetworkingError.Timeout:
                self.showAlertError(id: 0, text: "")
            case NetworkingError.NoInternet:
                self.showAlertError(id: 1, text: "")
            case CatalogError.NotFoundPlaces:
                self.favoritesPlaces = []
                self.tableView.reloadData()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func setFavoritePlace() {
        APIVirtualLines.setFavorite(number: self.phone, body: self.placeFavorite).debug("APIVirtualLines.SetFavoritePlace").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.favoritesPlaces.remove(at: self.cellRemove)
            self.tableView.reloadData()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.setFavoritePlace()
            case CatalogError.ErrorGeneral(let response):
                self.showAlertError(id: 2, text: response.message)
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
    
    func haveAddress() -> Bool? {
        let placeData = UserDefaults.standard.data(forKey: "address")
        if placeData == nil {
            return false
        }else {
            return true
        }
        
    }
    
    func reloadTables(sender: UITapGestureRecognizer) {
        self.placeFavorite.favorites.status = false
        self.placeFavorite.favorites.storeId = self.favoritesPlaces[(sender.view?.tag)!].storeDetail!.id
        self.cellRemove = sender.view!.tag
        setFavoritePlace()
    }
    
    func pressFavorite(sender: UIButton) {
        print("Favorite")
    }
    
//    Mark Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        if frequentPlaces.count == 0 && favoritesPlaces.count == 0 {
            return 1
        }else if frequentPlaces.count == 0 && favoritesPlaces.count != 0 {
            return 1
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.favoritesPlaces.count != 0 {
                flagEmptyTable = false
                return self.favoritesPlaces.count
            }else {
                flagEmptyTable = true
                return 1
            }
        }else {
            return frequentPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.tableView.register(UINib(nibName: kStoreHeaderCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kStoreHeaderCellReuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeHeaderCell") as! storeHeaderCell
        if section == 1 && frequentPlaces.count != 0 {
            cell.setupView(title: Message.DSHEADERPREFERENCE.localized)
            return cell
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if flagEmptyTable {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyFavoriteViewCell", for: indexPath) as! emptyFavoriteViewCell
                cell.setupView()
                cell.selectionStyle = .none
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteViewCell", for: indexPath) as! favoriteViewCell
                cell.cellDelegate = self
                cell.setupCell(info: self.favoritesPlaces[indexPath.row], tag: indexPath.row)
                cell.selectionStyle = .none
                return cell
            }
        }else {
            let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataStoreCell") as! dataStoreCell
            //let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteViewCell", for: indexPath) as! favoriteViewCell
            //cell.cellDelegate = self
            //cell.setupCell(info: self.frequentPlaces[indexPath.row], tag: indexPath.row)
            cellDefault.favoriteButton.isHidden = true
            cellDefault.setupViewCell(store: self.frequentPlaces[indexPath.row])
            cellDefault.hideAnimation()
            cellDefault.selectionStyle = .none
            return cellDefault
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.storeSelected = self.favoritesPlaces[indexPath.row]
        }else {
            self.storeSelected = self.frequentPlaces[indexPath.row]
        }
        if haveAddress()! {
            self.performSegue(withIdentifier: SeguesIdentifiers.openShiftInformation.rawValue, sender: self)
        } else {
            self.performSegue(withIdentifier: SeguesIdentifiers.openShiftAddress.rawValue, sender: self)
        }
    }
    
    
}
