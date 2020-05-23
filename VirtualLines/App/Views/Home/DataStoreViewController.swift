//
//  dataStoreViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/26/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import CoreLocation
import SkeletonView

class DataStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating, CLLocationManagerDelegate, UISearchControllerDelegate, dataStoreDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag: DisposeBag = DisposeBag()
    let locationManager = CLLocationManager()
    let middleButton = UIButton.init(type: .custom)
    
    var lat: Double = 0
    var long: Double = 0
    var category: Int = 0
    var titleView: String = ""
    
    var phone = AppInfo().phone
    var flagFavorites: Bool = true
    var flagExecuteFav: Bool = true
    var flagSkeleton: Bool = false
    var flagEmptyNearPlaces: Bool = true
    var flagEmptysearch: Bool = true
    var flagSearch: Bool = false
    var flagTable: Bool = true
    
    var stores: [DataStore] = []
    var arrayFilter = [DataStore]()
    var arrayPlacesFind = [DataStore]()
    var arrayFrequent = [DataStore]()
    var images: [UIImage] = [UIImage]()
    var storeSelected: DataStore = DataStore()
    var placeFavorite: Favorites = Favorites()
    var arrayFav: [String] = [String]()
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lat = AppInfo().userLat
        long = AppInfo().userLong
        self.tableView.isSkeletonable = true
        AppInfo().category = category
        self.tabBarController?.tabBar.isHidden = true
        setTitleChild(titleView)
        setupUI()
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
        self.searchController.searchBar.scopeButtonTitles = ["Cercanas", "Mejores Evaluadas", "Abiertas"]
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.becomeFirstResponder()
        self.searchController.searchBar.tintColor = kColorTextSB
        self.searchController.searchBar.backgroundColor = kColorSearchBar
        self.searchController.searchBar.barTintColor = kColorTextSB
        self.searchController.searchBar.borderWidth = 0
        self.searchController.searchBar.borderColor = kColorSearchBar
        self.searchController.searchBar.backgroundImage = UIImage()
        self.searchController.searchBar.clipsToBounds = true
        self.tabBarController?.tabBar.layer.borderWidth = 0
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.resultsController.tableView.tableFooterView = UIView()
        //self.resultsController.tableView.tableHeaderView = UIView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9715679288, green: 0.9767023921, blue: 0.9850376248, alpha: 1)
        tableView.separatorStyle = .none
        self.resultsController.tableView.backgroundColor = #colorLiteral(red: 0.9715679288, green: 0.9767023921, blue: 0.9850376248, alpha: 1)
        tableView?.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        tableView?.register(UINib(nibName: kStoreHeaderCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kStoreHeaderCellReuseIdentifier)
        tableView?.register(UINib(nibName: kEmptyPlacesCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kEmptyPlacesCellReuseIdentifier)
        //initLocation()
        //getFavoritesPlaces()
        getNearPlaces()
        creatingSearchBar()
        tableSettings()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            if AppInfo().isUserHost {
                UIStoryboard.loadMenuHost()
            }else {
                UIStoryboard.loadMenu()
            }
        } 
    }
    
    private func setupUI() {
        //Item bar button
        let image = resizeImage(image: UIImage(named: "PinPlaces")!, targetSize: CGSize(width:30.0, height:30.0))
        let placesButton = UIButton.init(type: .custom)
        placesButton.setImage(image, for: UIControl.State.normal)
        placesButton.frame = CGRect.init(x: 0, y: 0, width: 10, height: 30)
        placesButton.addTarget(self, action: #selector(DataStoreViewController.barButtonCustomPressed), for: .touchUpInside)
        let itemPlaces = UIBarButtonItem(customView: placesButton)
        self.navigationItem.rightBarButtonItem = itemPlaces
    }
    
    func initLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func showAlertImageZoom(images: [images], category: Int) {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "ImageZoomViewController") as! ImageZoomViewController
        customAlert.images = images
        customAlert.category = self.category
        self.view.addSubview(customAlert.view)
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
        }
    }
    
    func creatingSearchBar() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Busca tu tienda", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        if let textfield = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            textfield.tintColor = UIColor.blue
            textfield.placeholder = "Busca tu tienda"
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
                backgroundview.tintColor = UIColor.blue
            }
        }
        self.searchController.searchBar.placeholder = "Search"
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        //self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    func tableSettings() {
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
    }
    
    func haveAddress() -> Bool? {
        let placeData = UserDefaults.standard.data(forKey: "address")
        if placeData == nil {
            return false
        }else {
            return true
        }
        
    }
    
    func getFavoritesPlaces() {
        print ("Places")
        /*let parameters = createBody()
        let body = ["location":parameters]
        APIVirtualLines.getFavoritesPlaces(body: body, category: category).debug("APIVirtualLines.FavoritesPlaces").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.arrayFrequent = dataResponse.places!
            self.getNearPlaces()
        }, onError: {(error) in
            print("onError")
            print (error)
            switch error {
            case CatalogError.NotFoundPlaces:
                self.flagFavorites = false
                self.flagSkeleton = true
                self.tableView.reloadData()
                self.getNearPlaces()
            case CatalogError.TokenRenew:
                self.getFavoritesPlaces()
            default:
                break
            }
        }, onCompleted: {() in
            print ("Completed")
        }).disposed(by: disposeBag)*/
    }
    
    func getFavPlaces(phone: String) {
        APIVirtualLines.getFavoritesPlaces(number: phone).debug("APIVirtualLines.getFavoritesPlaces").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            for place in dataResponse.places! {
                self.arrayFav.append("\(place.storeDetail?.id ?? 0)")
            }
            AppInfo().arrayFavorites = self.arrayFav
            self.tableView.reloadData()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getFavPlaces(phone: phone)
            case CatalogError.NoLinesFound(let response):
                AppInfo().arrayFavorites = []
                self.tableView.reloadData()
            case NetworkingError.Timeout:
                self.showAlertError(id: 0, text: "")
            case NetworkingError.NoInternet:
                self.showAlertError(id: 1, text: "")
            case CatalogError.NotFoundPlaces:
                AppInfo().arrayFavorites = []
                self.tableView.reloadData()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    
    func getNearPlaces() {
        self.flagFavorites = false
        let parameters = createBody()
        let body = ["location":parameters]
        APIVirtualLines.getNearPlaces(body: body, category: category).debug("APIVirtualLines.NearPlaces").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.flagEmptyNearPlaces = false
            self.stores = dataResponse.places!
            self.flagSkeleton = true
            self.getFavPlaces(phone: self.phone)
            //self.tableView.reloadData()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getNearPlaces()
            case CatalogError.NotFoundPlaces:
                self.flagEmptyNearPlaces = true
                self.tableView.reloadData()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func findPlaces(text: String) {
        let body = ["location":nil] as [String : Any?]
        APIVirtualLines.findPlacesByAny(body: body, text: text).debug("APIVirtualLines.FindPlacesAny").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.arrayPlacesFind = dataResponse.places!
            self.flagSkeleton = true
            self.filtersPlaces()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getNearPlaces()
            case CatalogError.NotFoundPlaces:
                self.flagEmptysearch = true
                self.resultsController.tableView.reloadData()
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
            AppInfo().arrayFavorites = self.arrayFav
            //self.tableView.reloadData()
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
            customAlert.view.removeFromSuperview()
        }
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["lat"] = lat
        bodyCollection["lng"] = long
        return bodyCollection
    }
    
    func createBodyNil() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["lat"] = nil
        bodyCollection["lng"] = nil
        return bodyCollection
    }
    
    @objc private func barButtonCustomPressed () {
        self.performSegue(withIdentifier: SeguesIdentifiers.openMapPulley.rawValue, sender: self)
    }
    
    @objc func buttonAction() {
        middleButton.isSelected = true
        self.tabBarController?.selectedIndex = 2
    }
    
    func imagePressed(image: UIButton) {
        if flagTable {
            showAlertImageZoom(images: stores[image.tag].storeDetail!.images, category: stores[image.tag].storeDetail!.storeCategoryId)
        }else {
            showAlertImageZoom(images: arrayFilter[image.tag].storeDetail!.images, category: arrayFilter[image.tag].storeDetail!.storeCategoryId)
        }
    }
    
    func favoritePressed(sender: UIButton) {
        var plac = AppInfo().arrayFavorites
        if !sender.isSelected {
            if flagTable {
                arrayFav.removeAll { $0 == "\(stores[sender.tag].storeDetail?.id ?? 0)" }
            }else {
                arrayFav.removeAll { $0 == "\(arrayFilter[sender.tag].storeDetail?.id ?? 0)" }
            }
            let image = resizeImage(image: UIImage(named: "UnselectFav")!, targetSize: CGSize(width: 30, height: 30))
            sender.setImage(image, for: .normal)
        }else {
            let image = resizeImage(image: UIImage(named: "Heart")!, targetSize: CGSize(width: 30, height: 30))
            sender.setImage(image, for: .normal)
        }
        if flagTable {
            plac?.append("\(self.stores[sender.tag].storeDetail!.id)")
            placeFavorite.favorites.status = sender.isSelected
            placeFavorite.favorites.storeId = self.stores[sender.tag].storeDetail!.id
        }else {
            plac?.append("\(self.arrayFilter[sender.tag].storeDetail!.id)")
            placeFavorite.favorites.status = sender.isSelected
            placeFavorite.favorites.storeId = self.arrayFilter[sender.tag].storeDetail!.id
        }
        setFavoritePlace()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openShiftInformation.rawValue {
            let nextViewController = segue.destination as! PreviewShiftViewController
            nextViewController.stores = self.storeSelected
        }else {
            let nextViewController = segue.destination as! MapStoreViewController
            nextViewController.selectedStore = self.storeSelected
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openShiftInformation.rawValue {
            let nextViewController = segue.destination as! ShiftPreviewViewController
            nextViewController.stores = self.storeSelected
        }else {
            let nextViewController = segue.destination as! MapStoreViewController
            nextViewController.selectedStore = self.storeSelected
        }
    }*/
    
    //    MARK: Resultupdating
    func updateSearchResults(for searchController: UISearchController) {
        self.arrayPlacesFind = []
        self.arrayFilter = []
        flagSkeleton = false
        let textToSearch = self.searchController.searchBar.text!.lowercased()
        self.findPlaces(text: textToSearch)
        //Aqui va la busqueda de Api
        //findStore(store: self.stores, search: textToSearch)
        //self.resultsController.tableView.reloadData()
    }
    
    func filtersPlaces () {
        self.arrayFilter = []
        for place in arrayPlacesFind {
            if place.storeDetail?.storeCategoryId == category {
                self.arrayFilter.append(place)
            }
        }
        if arrayFilter.count == 0 {
            flagEmptysearch = true
        }else {
            flagEmptysearch = false
        }
        self.resultsController.tableView.reloadData()
    }
    
//    Mark Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = locValue.latitude
        long = locValue.longitude
        self.locationManager.stopUpdatingLocation()
        /*if flagExecuteFav {
            getFavoritesPlaces()
            flagExecuteFav = false
        }*/
    }
    
//    Mark TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            if flagEmptyNearPlaces {
                return 1
            }else {
                return stores.count
            }
            
        }else {
            if flagEmptysearch {
                return 1
            }else {
                return arrayFilter.count
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            if flagFavorites {
                return 2
            }else {
                return 1
            }
        }else if flagEmptyNearPlaces {
            return 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.tableView.register(UINib(nibName: kStoreHeaderCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kStoreHeaderCellReuseIdentifier)
        self.resultsController.tableView.register(UINib(nibName: kStoreHeaderCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kStoreHeaderCellReuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeHeaderCell") as! storeHeaderCell
        if section == 0 && flagFavorites {
            cell.setupView(title: Message.DSHEADERPREFERENCE.localized)
        }else if flagEmptyNearPlaces {
            cell.setupView(title: "")
        } else {
            cell.setupView(title: Message.DSHEADERNEARBY.localized)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9715679288, green: 0.9767023921, blue: 0.9850376248, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView?.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        self.tableView?.register(UINib(nibName: kEmptyPlacesCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kEmptyPlacesCellReuseIdentifier)
        self.resultsController.tableView?.register(UINib(nibName: kEmptyPlacesCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kEmptyPlacesCellReuseIdentifier)
        self.resultsController.tableView?.register(UINib(nibName: kDataStoreCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kDataStoreCellReuseIdentifier)
        if tableView == self.tableView {
            flagTable = true
            flagSearch = false
            if flagEmptyNearPlaces {
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "emptyPlacesViewCell") as! emptyPlacesViewCell
                cellDefault.setupView(id: 0)
                cellDefault.selectionStyle = .none
                return cellDefault
            }else {
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataStoreCell") as! dataStoreCell
                cellDefault.cellDelegate = self
                if flagSkeleton {
                    cellDefault.hideAnimation()
                    //cellDefault.setupView(name: stores[indexPath.row].storeDetail!.name, address: stores[indexPath.row].storeDetail!.storeAddress!.street, category: stores[indexPath.row].storeDetail!.storeCategoryId) //Aqui se tiene que corregir aopina
                    cellDefault.favoriteButton.tag = indexPath.row
                    cellDefault.imageButton.tag = indexPath.row
                    cellDefault.setupFavorite(store: stores[indexPath.row], favorite: arrayFav)
                    cellDefault.setupViewCell(store: stores[indexPath.row])
                }
                cellDefault.selectionStyle = .none
                return cellDefault
            }
            
        }else {
            flagTable = false
            flagSearch = true
            if flagEmptysearch {
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "emptyPlacesViewCell") as! emptyPlacesViewCell
                cellDefault.setupView(id: 1)
                cellDefault.selectionStyle = .none
                return cellDefault
            }else {
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "dataStoreCell") as! dataStoreCell
                cellDefault.cellDelegate = self
                if flagSkeleton {
                    cellDefault.hideAnimation()
                    cellDefault.favoriteButton.tag = indexPath.row
                    cellDefault.imageButton.tag = indexPath.row
                    cellDefault.setupFavorite(store: arrayFilter[indexPath.row], favorite: arrayFav)
                    cellDefault.setupViewCell(store: arrayFilter[indexPath.row])
                }
                cellDefault.selectionStyle = .none
                return cellDefault
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            self.storeSelected = stores[indexPath.row]
            if haveAddress()! {
                self.performSegue(withIdentifier: SeguesIdentifiers.openShiftInformation.rawValue, sender: self)
            } else {
                self.performSegue(withIdentifier: SeguesIdentifiers.openShiftAddress.rawValue, sender: self)
            }
        }else {
            self.storeSelected = arrayFilter[indexPath.row]
            if haveAddress()! {
                self.performSegue(withIdentifier: SeguesIdentifiers.openShiftInformation.rawValue, sender: self)
            } else {
                self.performSegue(withIdentifier: SeguesIdentifiers.openShiftAddress.rawValue, sender: self)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
           stores.sort {$0.distance > $1.distance }
        case 1:
           stores.sort {$0.storeDetail?.storeRating ?? 0 > $1.storeDetail?.storeRating ?? 0}
        default:
            break
        }
        //self.resultsController.tableView.reloadData()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var textStore = ""
        let favorite = UIContextualAction(style: .normal, title: "Favorito") { (action, view, completionHandler) in
            if tableView == self.tableView {
                self.placeFavorite.favorites.status = true
                self.placeFavorite.favorites.storeId = self.stores[indexPath.row].storeDetail!.id
                self.setFavoritePlace()
            }else {
                self.placeFavorite.favorites.status = true
                self.placeFavorite.favorites.storeId = self.arrayFilter[indexPath.row].storeDetail!.id
                self.setFavoritePlace()
            }
            completionHandler(true)
        }
        favorite.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        favorite.image = resizeImage(image: UIImage(named: "Heart")!, targetSize: CGSize(width: 30, height: 30))
        let share = UIContextualAction(style: .normal, title: "Compartir") { (action, view, completionHandler) in
            if tableView == self.tableView {
                textStore = self.stores[indexPath.row].storeDetail!.name
            }else {
                textStore = self.arrayFilter[indexPath.row].storeDetail!.name
            }
            let text = "Mira el tiempo que ahorre en " + textStore + " a través de HoldLine"
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
            completionHandler(true)
        }
        share.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        share.image = resizeImage(image: UIImage(named: "Share")!, targetSize: CGSize(width: 30, height: 30))
        if indexPath.section == 0 {
            return UISwipeActionsConfiguration(actions: [favorite, share])
        }
        let configuration = UISwipeActionsConfiguration(actions: [favorite])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}

extension UITextField {
    func setPlaceholderText(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: color])
    }
}

