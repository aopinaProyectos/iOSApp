//
//  MapStoreViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/26/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Pulley

class MapStoreViewController: PulleyViewController {

    var stores: [DataStore]?
    var containerViewController: MapStoreGmapViewController?
    var selectedStore: DataStore?
    
    override func viewDidLoad() {
        let primaryContent = UIStoryboard(name: "Stores", bundle: nil).instantiateViewController(withIdentifier: "PrimaryContentViewController")
        let drawerContent = UIStoryboard(name: "Stores", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController")
        
        self.setPrimaryContentViewController(controller: primaryContent, animated: true)
        self.setDrawerContentViewController(controller: drawerContent, animated: false)
        
        setNeedsSupportedDrawerPositionsUpdate()
        setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
    }
    
    func reloadTableView() {
        let CVC = children.last as! MapStoreTableViewController
        CVC.storesArray = self.stores!
        CVC.reloadDataTable()
    }
    
    func pulleyCollapsed() {
        self.setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
    }
    
    func pulleyRevealed() {
         self.setDrawerPosition(position: PulleyPosition.partiallyRevealed, animated: true)
    }
    
    func selectStore() {
        let CVC = children[2] as! MapStoreGmapViewController
        CVC.selectedStore = self.selectedStore
        CVC.selectMarker()
    }
    
    func shiftPressed() {
        self.performSegue(withIdentifier: SeguesIdentifiers.openShiftInformation.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.embbedChildStoreMapSegueID.rawValue {
            let nextViewController = segue.destination as! MapStoreGmapViewController
            nextViewController.handlerPulley = {
                print("Imprimir Pulley ---------------------------------")
                self.setDrawerPosition(position: PulleyPosition.collapsed, animated: true)
            }

        }else if segue.identifier == SeguesIdentifiers.openShiftInformation.rawValue {
            let nextViewController = segue.destination as! ShiftPreviewViewController
            nextViewController.stores = selectedStore!
        }
    }
}
