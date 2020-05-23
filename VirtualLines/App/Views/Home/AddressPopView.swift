//
//  AddressPopView.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddressPopView: UIViewController, UITableViewDelegate, UITableViewDataSource, addressPopCell2Delegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var count = 0
    var countUnselect = 0
    var addressArray: [AddressUser] = []
    var addressUnselect: [AddressUser] = []
    var userAddress: LocationSave = LocationSave()
    var flagNil = false
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppInfo().addressViewIsShow = true
        AppInfo().addressAlert = false
        loadAddress()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView?.register(UINib(nibName: kAddressPopCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kAddressPopCellReuseIdentifier)
        tableView?.register(UINib(nibName: kAddressPopCell2ReuseIdentifier, bundle: nil), forCellReuseIdentifier: kAddressPopCell2ReuseIdentifier)
        self.tableView.separatorStyle = .none
    }
    
    func updateUserAddress() {
        APIVirtualLines.updateAddress(location: userAddress).debug("APIVirtualLines.UpdateAddress").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.countUnselect = self.countUnselect + 1
            if self.addressUnselect.count == self.countUnselect {
                self.dismiss(animated: true, completion: nil)
            }
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.updateUserAddress()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func loadAddress() {
        let placeData = UserDefaults.standard.data(forKey: "address")
        if placeData == nil {
            flagNil = true
            count = 0
        }else {
            let placeArray = try! JSONDecoder().decode([AddressUser].self, from: placeData!)
            if placeArray.count == 0 {
                flagNil = true
                count = 0
            }else {
                addressArray = placeArray
                count = placeArray.count
            }
        }
    }
    
    func removeAddress(sender: UIButton) {
        userAddress.lat = addressArray[sender.tag].latitude
        userAddress.lng = addressArray[sender.tag].longitude
        userAddress.name = addressArray[sender.tag].name
        userAddress.phoneNumber = AppInfo().phone
        userAddress.id = addressArray[sender.tag].id
        userAddress.selected = addressArray[sender.tag].active
        userAddress.active = 0
        updateUserAddress()
        addressArray.remove(at: sender.tag)
        savePlaces()
        count = addressArray.count
        if count == 0 {
            flagNil = true
        }else {
            flagNil = false
        }
        self.tableView.reloadData()
    }
    
    func savePlaces() {
        let placesData = try! JSONEncoder().encode(addressArray)
        UserDefaults.standard.set(placesData, forKey: "address")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if flagNil {
            switch indexPath.row {
            case 0...1:
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "addressPopCell") as! addressPopCell
                cellDefault.setupView(index: indexPath.row, maps: true)
                return cellDefault
            default:
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "addressPopCell") as! addressPopCell
                return cellDefault
            }
        }else {
            switch indexPath.row {
            case 0:
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "addressPopCell") as! addressPopCell
                cellDefault.setupView(index: indexPath.row, maps: true)
                return cellDefault
            case 1...count:
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "addressPopCell2") as! addressPopCell2
                cellDefault.buttonRemove.tag = indexPath.row - 1
                cellDefault.cellDelegate = self
                cellDefault.setupView(myAddress: addressArray[indexPath.row - 1])
                return cellDefault
            case (count + 2) - 1:
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "addressPopCell") as! addressPopCell
                cellDefault.setupView(index: 1, maps: true)
                return cellDefault
            default:
                let cellDefault = tableView.dequeueReusableCell(withIdentifier: "addressPopCell") as! addressPopCell
                return cellDefault
            }
        }
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: "addressPopCell") as! addressPopCell
        return cellDefault
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flagNil {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: SeguesIdentifiers.openAddressPopView3.rawValue, sender: self)
            case 1:
                self.performSegue(withIdentifier: SeguesIdentifiers.openAddressPopView2.rawValue, sender: self)
            default:
                break
            }
        }else {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: SeguesIdentifiers.openAddressPopView3.rawValue, sender: self)
            case 1...count:
                for add in addressArray {
                    add.active = false
                }
                addressArray[indexPath.row - 1].active = true
                userAddress.lat = addressArray[indexPath.row - 1].latitude
                userAddress.lng = addressArray[indexPath.row - 1].longitude
                userAddress.name = addressArray[indexPath.row - 1].name
                userAddress.phoneNumber = AppInfo().phone
                userAddress.id = addressArray[indexPath.row - 1].id
                userAddress.selected = addressArray[indexPath.row - 1].active
                addressUnselect = []
                for add in addressArray {
                    addressUnselect.append(add)
                }
                savePlaces()
                loadAddress()
                self.tableView.reloadData()
                AppInfo().addressAlert = false
                for add in addressUnselect {
                    userAddress.lat = add.latitude
                    userAddress.lng = add.longitude
                    userAddress.name = add.name
                    userAddress.phoneNumber = AppInfo().phone
                    userAddress.id = add.id
                    userAddress.selected = add.active
                    updateUserAddress()
                }
                //self.dismiss(animated: true, completion: nil)
            case (count + 2) - 1:
                self.performSegue(withIdentifier: SeguesIdentifiers.openAddressPopView2.rawValue, sender: self)
            default:
                break
            }
        }
        
    }
    
}
