//
//  dataShiftHostViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kDataShiftHostViewCellReuseIdentifier = "dataShiftHostViewCell"

class dataShiftHostViewCell: UITableViewCell {
    
    @IBOutlet weak var shiftLabel: UILabel!
    @IBOutlet weak var shiftNameUser: UILabel!
    @IBOutlet weak var shiftTimeLabel: UILabel!
    @IBOutlet weak var shiftStatusLabel: UILabel!
    
    func setupView(shift: ShiftDataString, name: String) {
        shiftLabel.text = shift.shift
        shiftNameUser.text = name
        shiftTimeLabel.text = shift.shiftTime
        shiftStatusLabel.text = applyLocalizationStatus(status: shift.status)
    }
    
}
