//
//  nameMoreViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/25/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kNameMoreViewCellReuseIdentifier = "nameMoreViewCell"

class nameMoreViewCell: UITableViewCell {
    
    @IBOutlet weak var greetingsLabel: UILabel!
    
    func setupView() {
        greetingsLabel.text = checkGreeting() + AppInfo().nameUser
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
        text = currentTimeOfDay + " "
        return text
    }
}
