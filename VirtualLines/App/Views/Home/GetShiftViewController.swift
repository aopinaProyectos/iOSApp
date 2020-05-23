//
//  GetShiftViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/20/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Pulley

class GetShiftViewController: PulleyViewController {
    
    var containerViewController: ShiftMapViewController?
    var lat: Double = 0
    var lon: Double = 0
    var name: String = ""
    var store: DataStore = DataStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setupView()
        let primaryContent = UIStoryboard(name: "GetShift", bundle: nil).instantiateViewController(withIdentifier: "PrimaryContentViewController")
        let drawerContent = UIStoryboard(name: "GetShift", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController")
        
        self.setPrimaryContentViewController(controller: primaryContent, animated: true)
        self.setDrawerContentViewController(controller: drawerContent, animated: false)
        
        setNeedsSupportedDrawerPositionsUpdate()
        setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
    }
    
    func setupView() {
        self.setOpaqueNavigationBar()
        self.setTitleChild("Agrega tu dirección")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.embbedChildShiftMapSegueID.rawValue {
            let nextViewController = segue.destination as! ShiftMapViewController
            nextViewController.handlerPulley = {
                print("Imprimir Pulley ---------------------------------")
                self.setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
            }
        }else if segue.identifier == SeguesIdentifiers.openShiftInformation.rawValue {
            let nextViewController = segue.destination as! ShiftInformationViewController
            nextViewController.stores = store
        }
    }
    
    func savePlaces() {
        var placesArray: [AddressUser] = []
        placesArray.append(AddressUser(id: 10, latitude: lat, longitude: lon, name: name, address: name, active: false))
        let placesData = try! JSONEncoder().encode(placesArray)
        UserDefaults.standard.set(placesData, forKey: "address")
    }
    
    func pulleyCollapsed() {
        self.setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
    }
    
    func pulleyRevealed() {
        self.setDrawerPosition(position: PulleyPosition.partiallyRevealed, animated: true)
    }
    
    func pulleyOpen() {
        self.setDrawerPosition(position: PulleyPosition.open, animated: true)
    }
    
    func pulleyClose() {
        self.setDrawerPosition(position: PulleyPosition.closed, animated: true)
    }
    
    func nextView() {
        savePlaces()
        self.performSegue(withIdentifier: SeguesIdentifiers.openShiftInformation.rawValue, sender: self)
    }
    
}
