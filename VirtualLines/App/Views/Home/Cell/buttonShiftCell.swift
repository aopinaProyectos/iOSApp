//
//  buttonShiftCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kButtonShiftCellReuseIdentifier = "buttonShiftCell"

class buttonShiftCell: UITableViewCell {
    
    @IBOutlet weak var buttonLabel: UILabel!
    
    
    func setupCell(text: String) {
        buttonLabel.text = text
    }
    
}
