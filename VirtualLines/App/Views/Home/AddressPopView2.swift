//
//  AddressPopView2.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps


class AddressPopView2: UIViewController, GMSMapViewDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {
    
    var latitude: Double = 0
    var longitude: Double = 0
    var address: String = ""
    
    @IBOutlet weak var mapsTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.mapsTextField.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openAddressPopView3.rawValue {
            let viewController = segue.destination as! AddressPopView3
            viewController.comeFromautocomplete = true
            viewController.latSearch = latitude
            viewController.lonSearch = longitude
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        address = place.formattedAddress!
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: SeguesIdentifiers.openAddressPopView3.rawValue, sender: self)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}

    


