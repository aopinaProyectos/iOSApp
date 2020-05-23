//
//  addressPopCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kAddressPopCellReuseIdentifier = "addressPopCell"

class addressPopCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    func setupView(index: Int, maps: Bool) {
        if maps {
            switch index {
            case 0:
                icon.image = UIImage(named: "Arrow")
                optionLabel.text = "Ubicación Actual"
            default:
                icon.image = UIImage(named: "Placeholder")
                optionLabel.text = "Agregar una ubicación"
            }
        }
        
    }
}
