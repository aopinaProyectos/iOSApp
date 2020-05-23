//
//  addressPopCell2.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kAddressPopCell2ReuseIdentifier = "addressPopCell2"

protocol addressPopCell2Delegate : class {
    func removeAddress(sender: UIButton)
}

class addressPopCell2: UITableViewCell {
    
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var buttonRemove: UIButton!
    
    weak var cellDelegate: addressPopCell2Delegate?
    
    func setupView(myAddress: AddressUser) {
        self.name.text = myAddress.name
        self.address.text = myAddress.address
        self.check.isHidden = !myAddress.active
        self.imageAdd.image = getImageAddress(named: myAddress.name)
    }
    
    func getImageAddress(named: String) -> UIImage{
        switch named {
        case "Casa":
            return resizeImage(image: UIImage(named: "House")!, targetSize: CGSize(width: 30, height: 30))
        case "Oficina":
            return resizeImage(image: UIImage(named: "Office")!, targetSize: CGSize(width: 30, height: 30))
        case "Otro":
            return resizeImage(image: UIImage(named: "Other")!, targetSize: CGSize(width: 30, height: 30))
        case "Novi@":
            return resizeImage(image: UIImage(named: "Girlfriend")!, targetSize: CGSize(width: 30, height: 30))
        default:
            return resizeImage(image: UIImage(named: "Other")!, targetSize: CGSize(width: 30, height: 30))
        }
    }
    
    @IBAction func removeButton(sender: UIButton) {
        cellDelegate!.removeAddress(sender: sender)
    }
    
}
