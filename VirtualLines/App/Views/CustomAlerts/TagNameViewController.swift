//
//  TagNameViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/10/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class TagNameViewController: PopupAlertViewController {
    
    @IBOutlet weak var houseButton: UIButton!
    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var girlfriendButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var savePlaces: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var otherFieldText: UITextField!
    
    var name = ""
    var addressArray: [AddressUser] = [AddressUser]()
    var addressUnselect: [AddressUser] = [AddressUser]()
    var userAddress: LocationSave = LocationSave()
    var userAddressUns: LocationSave = LocationSave()
    var lat: Double = 0
    var long: Double = 0
    var countUnselect = 0
    var address = ""
    var active = true
    var handlerCloseView: () -> () = {}
    
    let disposeBag: DisposeBag = DisposeBag()
    
    func setupView() {
        otherFieldText.placeholder = Message.PHDOTHER.localized
        otherFieldText.isHidden = true
        otherFieldText.borderStyle = .none
        otherFieldText.borderWidth = 0
        lineView.isHidden = true
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            sender.isSelected = true
            officeButton.isSelected = false
            girlfriendButton.isSelected = false
            otherButton.isSelected = false
            otherFieldText.isHidden = true
            lineView.isHidden = true
            self.name = "Casa"
            print("Casa")
        case 1:
            sender.isSelected = true
            houseButton.isSelected = false
            girlfriendButton.isSelected = false
            otherButton.isSelected = false
            otherFieldText.isHidden = true
            lineView.isHidden = true
            self.name = "Oficina"
            print("Oficina")
        case 2:
            sender.isSelected = true
            houseButton.isSelected = false
            officeButton.isSelected = false
            otherButton.isSelected = false
            girlfriendButton.isSelected = true
            otherFieldText.isHidden = true
            lineView.isHidden = true
            self.name = "Novi@"
            print("Novi@")
        case 3:
            sender.isSelected = true
            houseButton.isSelected = false
            officeButton.isSelected = false
            otherButton.isSelected = true
            girlfriendButton.isSelected = false
            otherFieldText.isHidden = false
            lineView.isHidden = false
            self.name = "Otro"
        default:
            break
        }
    }
    
    func loadAddress() {
        let placeData = UserDefaults.standard.data(forKey: "address")
        if placeData == nil {
            print("Error")
        }else {
            let placeArray = try! JSONDecoder().decode([AddressUser].self, from: placeData!)
            addressArray = placeArray
            for add in addressArray {
                add.active = false
            }
        }
    }
    
    func unselectData() {
        for add in addressUnselect {
            userAddressUns.lat = add.latitude
            userAddressUns.lng = add.longitude
            userAddressUns.name = add.name
            userAddressUns.phoneNumber = AppInfo().phone
            userAddressUns.id = add.id
            userAddressUns.selected = false
            updateUserAddressUns()
        }
    
    
    }
    
    func updateUserAddressUns() {
        APIVirtualLines.updateAddress(location: userAddressUns).debug("APIVirtualLines.UpdateAddress").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.countUnselect = self.countUnselect + 1
            if self.addressUnselect.count == self.countUnselect {
                self.handlerCloseView()
                self.close()
            }
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.updateUserAddressUns()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func saveUserAddress() {
        APIVirtualLines.saveAddress(location: userAddress).debug("APIVirtualLines.SavAddress").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.addressUnselect = []
            self.loadAddress()
            for add in self.addressArray {
                self.addressUnselect.append(add)
            }
            for add in self.addressArray {
                add.active = false
            }
            self.addressArray.append(AddressUser(id: self.userAddress.id
                , latitude: self.userAddress.lat, longitude: self.userAddress.lng, name: self.userAddress.name, address: self.address, active: self.active))
            let placesData = try! JSONEncoder().encode(self.addressArray)
            UserDefaults.standard.set(placesData, forKey: "address")
            AppInfo().haveAddressUser = true
            self.unselectData()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.saveUserAddress()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    @IBAction func saveData() {
        //loadAddress()
        if otherButton.isSelected {
            if otherFieldText.text == "" {
                lineView.backgroundColor = UIColor.red
            }else {
                name = otherFieldText.text!
                userAddress.name = name
                userAddress.lat = lat
                userAddress.lng = long
                userAddress.selected = true
                userAddress.phoneNumber = AppInfo().phone
                saveUserAddress()
                /*addressArray.append(AddressUser(latitude: lat, longitude: long, name: name, address: address, active: active))
                let placesData = try! JSONEncoder().encode(addressArray)
                UserDefaults.standard.set(placesData, forKey: "address")*/
            }
            
        }else {
            userAddress.name = name
            userAddress.lat = lat
            userAddress.lng = long
            userAddress.selected = true
            userAddress.phoneNumber = AppInfo().phone
            saveUserAddress()
            /*addressArray.append(AddressUser(latitude: lat, longitude: long, name: name, address: address, active: active))
            let placesData = try! JSONEncoder().encode(addressArray)
            UserDefaults.standard.set(placesData, forKey: "address")*/
            //self.handlerCloseView()
            //self.close()
        }
    }
}
