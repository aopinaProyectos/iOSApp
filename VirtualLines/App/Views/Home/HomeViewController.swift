//
//  HomeViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import ImageSlideshow
import RxSwift
import GoogleMaps

class HomeViewController: CustomTabBarViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BottomPopupDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSlideImages: ImageSlideshow!
    @IBOutlet weak var searchButton: UIButton!
    
    let middleButton = UIButton.init(type: .custom)
    let button = UIButton(type: .system)
    
    private var mainView: MainView!
    private var didSetupConstraints = false
    
    var cat: [Category]? = [Category]()
    var optionsMenu: [optionMenu]? = [optionMenu]()
    var addressArray: [AddressUser] = [AddressUser]()
    var userLocations: [Locations] = [Locations]()
    var categorySelected: Int = 0
    var counterAdd = 0
    var index: Int = 0
    var selectedAddress = ""
    var phone = AppInfo().phone
    var emptyAddress = false
    var comeFromPop = false
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupBar()
        setupView()
        setTabBarSwipe(enabled: false)
        //getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        counterAdd = 0
        addressArray = []
        getCategories()
        if !AppInfo().isUserHost {
           setupBar()
        }
        //setupBar()
        self.showTabBar()
        self.setOpaqueNavigationBar()
        //self.setTitleChild(checkGreeting())
        self.loadBanners()
        collectionView.delegate = self
        collectionView.dataSource = self
        getUserAddress()
        loadAddress()
        //createButton()
        getAllShiftActive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        middleButton.isSelected = false
    }
    
    func loadAddress() {
      if AppInfo().haveAddressUser {
         let placeData = UserDefaults.standard.data(forKey: "address")
         let placeArray = try! JSONDecoder().decode([AddressUser].self, from: placeData!)
         addressArray = placeArray
         if placeArray.count != 0 {
            for add in addressArray {
               if add.active {
                  self.selectedAddress = add.name
                  AppInfo().userLat = add.latitude
                  AppInfo().userLong = add.longitude
                  AppInfo().addressName = add.name
               }
            }
            if selectedAddress == "" {
               self.selectedAddress = addressArray.first!.name
               AppInfo().userLat = addressArray.first!.latitude
               AppInfo().userLong = addressArray.first!.longitude
            }
            emptyAddress = false
         }else {
            emptyAddress = true
         }
      }else {
         emptyAddress = true
         if !AppInfo().addressViewIsShow {
            didTapOnButton()
         }
      }
      
        /*let placeData = UserDefaults.standard.data(forKey: "address")
        if placeData == nil {
            if comeFromPop == false {
               guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "customNavController") as? PopViewController else { return }
               popupVC.height = CGFloat(AppInfo().screenHeigth / 2)
               popupVC.topCornerRadius = 35
               popupVC.presentDuration = 1.0
               popupVC.dismissDuration = 1.0
               popupVC.shouldDismissInteractivelty = true
               popupVC.popupDelegate = self
               present(popupVC, animated: true, completion: nil)
            }else {
               emptyAddress = true
               createButton()
            }
        }else {
            let placeArray = try! JSONDecoder().decode([AddressUser].self, from: placeData!)
            addressArray = placeArray
            if placeArray.count != 0 {
                for add in addressArray {
                    if add.active {
                        self.selectedAddress = add.name
                        AppInfo().userLat = add.latitude
                        AppInfo().userLong = add.longitude
                        AppInfo().addressName = add.name
                    }
                }
                if selectedAddress == "" {
                    self.selectedAddress = addressArray.first!.name
                  AppInfo().userLat = addressArray.first!.latitude
                  AppInfo().userLong = addressArray.first!.longitude
                }
                emptyAddress = false
            }else {
                emptyAddress = true
            }
        }*/
        
    }
    
    func getImageAddress(named: String) -> UIImage{
        switch named {
        case "Casa":
            return resizeImage(image: UIImage(named: "House")!, targetSize: CGSize(width: 15, height: 15))
        case "Oficina":
            return resizeImage(image: UIImage(named: "Office")!, targetSize: CGSize(width: 15, height: 15))
        case "Otro":
         return resizeImage(image: UIImage(named: "Other")!, targetSize: CGSize(width: 15, height: 15))
        case "Novi@":
         return resizeImage(image: UIImage(named: "Girlfriend")!, targetSize: CGSize(width: 15, height: 15))
        default:
         return resizeImage(image: UIImage(named: "Other")!, targetSize: CGSize(width: 15, height: 15))
        }
    }
    
    func createButton() {
        var title = ""
        let image = resizeImage(image: getImageAddress(named: selectedAddress), targetSize: CGSize(width: 15, height: 15))
        if emptyAddress  {
            title = " Selecciona Dirección  ▼"
        }else {
            title = "  " + selectedAddress + "  ▼"
        }
        //button.frame.size = CGSize(width: 40.0, height: 20.0)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.titleView = button
    }
    
    func setupBar(){
      var imageOrigin: UIImage = UIImage()
        if AppInfo().isUserHost {
           imageOrigin = self.resizeImage(image: UIImage(named: "Business")!, targetSize: CGSize(width: 45, height: 45))
        }else {
           imageOrigin = self.resizeImage(image: UIImage(named: "StoreTB")!, targetSize: CGSize(width: 45, height: 45))
        }
        let image = imageOrigin.tinted(with: #colorLiteral(red: 0.3621281683, green: 0.3621373773, blue: 0.3621324301, alpha: 1))
        let imageSelect = imageOrigin.tinted(with: #colorLiteral(red: 0.3111690581, green: 0.5590575933, blue: 0.8019174337, alpha: 1))
        middleButton.setImage(image, for: .normal)
        middleButton.setImage(imageSelect, for: .selected)
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = UIColor.white
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 10)
        middleButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.tabBarController?.tabBar.addSubview(middleButton)
        self.tabBarController?.tabBar.centerXAnchor.constraint(equalTo: middleButton.centerXAnchor).isActive = true
        self.tabBarController?.tabBar.topAnchor.constraint(equalTo: middleButton.centerYAnchor).isActive = true
        middleButton.isSelected = true
    }
    
    @objc func buttonAction() {
        middleButton.isSelected = true
        if AppInfo().isUserHost {
           self.tabBarController?.selectedIndex = 3
        } else {
           self.tabBarController?.selectedIndex = 2
        }
    }
    
    func setupView() {
        searchButton.borderWidth = 1
        searchButton.cornerRadius = 5
        let buttonImage = resizeImage(image: UIImage(named: "Search")!, targetSize: CGSize(width: 30, height: 30))
        searchButton.setImage(buttonImage, for: UIControl.State.normal)
        searchButton.setTitle(Message.PHDSEARCHBAR.localized, for: .normal)
        searchButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 4, bottom: 0.0, right: 1)
        self.viewSlideImages.frame.size.height = 240
        self.viewSlideImages.frame.size.width = CGFloat(AppInfo().screenWidth - 30)
    }
    
    func loadBanners() {
        configureSlideView()
    }
    
    private func configureSlideView(){
        
        viewSlideImages.setImageInputs([
            ImageSource(image: UIImage(named: "Banner1")!),
            ImageSource(image: UIImage(named: "Banner2")!)
        ])
        viewSlideImages.backgroundColor = UIColor.clear
        viewSlideImages.slideshowInterval = 5.0
        viewSlideImages.pageIndicatorPosition = PageIndicatorPosition.init()
        viewSlideImages.tintColor = kColorTabBar
        viewSlideImages.pageControl.pageIndicatorTintColor = UIColor.white
        viewSlideImages.contentScaleMode = UIView.ContentMode.scaleToFill
        
        viewSlideImages.currentPageChanged = { page in
            self.viewSlideImages.tag = page
        }
        
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTapSlideImage))
        //viewSlideImages.addGestureRecognizer(recognizer)
    }
    
    func getCategories(){
        APIVirtualLines.getCategories().debug("GetCategories").subscribe(onNext: {(categories) in
            print("onNext")
            print(categories)
            self.cat = categories.categories
            self.fillCategories()
            //self.cat = categories
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getCategories()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
   
   func createBadgets(count: Int) {
      if let tabItems = tabBarController?.tabBar.items {
         let tabItem = tabItems[1]
         let value = count
         if value > 0 {
            tabItem.badgeValue = "\(value)"
         }else {
            tabItem.badgeValue = nil
         }
      }
   }
   
   func getAddress() {
      if userLocations.count > 0 {
         var cord = CLLocationCoordinate2D()
         self.addressArray = []
         cord.latitude = userLocations[0].lat
         cord.longitude = userLocations[0].lng
         reverseGeocodeCoordinate(coordinate: cord, loc: userLocations[0])
      }else {
         loadAddress()
         createButton()
      }
   }
   
   func getUserAddress() {
      APIVirtualLines.getUserAddress(number: phone).debug("getUserAddress").subscribe(onNext: {(dataResponse) in
         print("onNext")
         self.userLocations = dataResponse.locations!
         self.getAddress()
      }, onError: {(error) in
         switch error {
         case CatalogError.TokenRenew:
            self.getUserAddress()
         case CatalogError.NotFoundPlaces:
            self.saveAddressEmpty()
            self.emptyAddress = true
            self.createButton()
         default:
            break
         }
         print("onError")
         print (error)
      }, onCompleted: {
         print ("Completed")
      }).disposed(by: disposeBag)
   }
   
   private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, loc: Locations) {
      var add = ""
      let geocoder = GMSGeocoder()
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
         guard let address = response?.firstResult(), let lines = address.lines else {
            return
         }
         add = lines.joined(separator: "\n")
         self.addressArray.append(AddressUser(id: loc.id, latitude: loc.lat, longitude: loc.lng, name: loc.name, address: add, active: loc.selected))
          /*if self.addressArray.count == self.userLocations.count {
             let placesData = try! JSONEncoder().encode(self.addressArray)
             UserDefaults.standard.set(placesData, forKey: "address")
             AppInfo().haveAddressUser = true
             self.loadAddress()
          }*/
          self.timeToSave()
      }
      //return add
   }
   
   func saveAddressEmpty() {
      let array: [AddressUser] = [AddressUser]()
      let placesData = try! JSONEncoder().encode(array)
      UserDefaults.standard.set(placesData, forKey: "address")
   }
   
   func timeToSave() {
      if addressArray.count == userLocations.count {
         let placesData = try! JSONEncoder().encode(self.addressArray)
         UserDefaults.standard.set(placesData, forKey: "address")
         AppInfo().haveAddressUser = true
         loadAddress()
         createButton()
      }else {
         var cord = CLLocationCoordinate2D()
         counterAdd = counterAdd + 1
         cord.latitude = userLocations[counterAdd].lat
         cord.longitude = userLocations[counterAdd].lng
         reverseGeocodeCoordinate(coordinate: cord, loc: userLocations[counterAdd])
         
      }
   }

   
   func getAllShiftActive() {
      APIVirtualLines.getAllShifts(phone: phone).debug("APIVirtualLines.getAllShiftActive").subscribe(onNext: {(dataResponse) in
         print ("onNext")
         self.createBadgets(count: dataResponse.shift!.count)
      }, onError: {(error) in
         print("onError")
         switch error {
         case CatalogError.TokenRenew:
            self.getAllShiftActive()
         case CatalogError.NoLinesFound(let response):
            self.createBadgets(count: 0)
         default:
            break
         }
      }, onCompleted: {
         print ("Completed")
      }).disposed(by: disposeBag)
   }
    
    func fillCategories() {
        self.optionsMenu = []
        for categor in cat! {
            self.optionsMenu?.append(optionMenu(title: categor.name, image: UIImage(named: "Enterteinment")!, section: categor.name))
            collectionView.reloadData()
            //self.optionsMenu?.insert(optionMenu(title: categor.name, image: UIImage(named: "Enterteinment")!, section: categor.name), at: categor.order)
        }
    }
    
    func showAlert() {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "TagNameViewController") as! TagNameViewController
        customAlert.lat = AppInfo().addressLat
        customAlert.long = AppInfo().addressLon
        customAlert.address = AppInfo().addressStreet
        self.view.addSubview(customAlert.view)
        
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
            self.loadAddress()
            self.createButton()
        }
    }
   
   func getGPSCordinates() {
      let locationManager = CLLocationManager()
      locationManager.requestAlwaysAuthorization()
      locationManager.requestWhenInUseAuthorization()
      if CLLocationManager.locationServicesEnabled() {
         switch CLLocationManager.authorizationStatus() {
         case .notDetermined, .restricted, .denied:
            AppInfo().isLocationEnabled = false
         case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            AppInfo().isLocationEnabled = true
         }
      }else {
         AppInfo().isLocationEnabled = false
      }

   }
    
    
    func checkGreeting() -> String {
        var text = ""
        var currentTimeOfDay = ""
        let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
        if hour >= 0 && hour < 12 {
            currentTimeOfDay = Message.MORNING.localized
        } else if hour >= 12 && hour < 17 {
            currentTimeOfDay = Message.AFTERNOON.localized
        } else if hour >= 17 {
            currentTimeOfDay = Message.EVENING.localized
        }
        text = currentTimeOfDay
        return text
    }
    
    @objc func didTapOnButton() {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "customNavController") as? PopViewController else { return }
        popupVC.height = CGFloat(AppInfo().screenHeigth / 2)
        popupVC.topCornerRadius = 35
        popupVC.presentDuration = 1.5
        popupVC.dismissDuration = 1.5
        popupVC.shouldDismissInteractivelty = true
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed() {
        self.performSegue(withIdentifier: SeguesIdentifiers.openSearchHome.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openStoreData.rawValue {
            let viewController = segue.destination as! DataStoreViewController
            viewController.category = categorySelected
            viewController.titleView = self.optionsMenu![index].title!
        }
    }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let locValue:CLLocationCoordinate2D = manager.location!.coordinate
      AppInfo().userLat = locValue.latitude
      AppInfo().userLong = locValue.longitude
   }
    
//    Mark Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsMenu!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : OptionMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OptionMenuCell
        cell.title.text = optionsMenu![indexPath.row].title
        //cell.imageSection.image = optionsMenu![indexPath.row].image
        cell.imageSection.image = kArraysImages[indexPath.row]
        
        cell.borderWidth = 0.8
        cell.borderColor = kColorBorderCell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 0
        
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.categorySelected = indexPath.row + 1
        self.performSegue(withIdentifier: SeguesIdentifiers.openStoreData.rawValue, sender: self)
    }
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
      print("bottomPopupWillDismiss")
      if AppInfo().haveAddressUser {
         self.comeFromPop = true
         self.loadAddress()
         self.createButton()
      }else {
         getGPSCordinates()
      }
    }
    
    func bottomPopupDidDismiss() {
        if AppInfo().addressAlert {
            showAlert()
        }
        
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
    

}
