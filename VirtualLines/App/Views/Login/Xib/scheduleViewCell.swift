//
//  scheduleViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0

let kScheduleCellReuseIdentifier = "scheduleViewCell"

class scheduleViewCell: UITableViewCell {
   
    @IBOutlet weak var dayLabel: UILabel?
    @IBOutlet weak var daySwitch: UISwitch?
    @IBOutlet weak var dayButton: UIButton?
    @IBOutlet weak var dayTimeLabel: UILabel?
    
    func setupCell(index: Int, days: [DayData]) {
        //dayButton?.tag = index
        //daySwitch?.tag = index
        switch index {
        case 0:
            dayLabel?.text = Message.MONDAY.localized
            dayTimeLabel?.text = days[index].time
            daySwitch?.tag = index
            daySwitch?.setOn(days[index].active, animated: true)
            checkActiveCell(days[index].active)
        case 1:
            dayLabel?.text = Message.TUESDAY.localized
            dayTimeLabel?.text = days[index].time
            daySwitch?.tag = index
            daySwitch?.setOn(days[index].active, animated: true)
            checkActiveCell(days[index].active)
        case 2:
            dayLabel?.text = Message.WEDNESDAY.localized
            dayTimeLabel?.text = days[index].time
            daySwitch?.tag = index
            daySwitch?.setOn(days[index].active, animated: true)
            checkActiveCell(days[index].active)
        case 3:
            dayLabel?.text = Message.THURSDAY.localized
            dayTimeLabel?.text = days[index].time
            daySwitch?.tag = index
            daySwitch?.setOn(days[index].active, animated: true)
            checkActiveCell(days[index].active)
        case 4:
            dayLabel?.text = Message.FRIDAY.localized
            dayTimeLabel?.text = days[index].time
            daySwitch?.tag = index
            daySwitch?.setOn(days[index].active, animated: true)
            checkActiveCell(days[index].active)
        case 5:
            dayLabel?.text = Message.SATURDAY.localized
            dayTimeLabel?.text = days[index].time
            daySwitch?.tag = index
            daySwitch?.setOn(days[index].active, animated: true)
            checkActiveCell(days[index].active)
        case 6:
            dayLabel?.text = Message.SUNDAY.localized
            dayTimeLabel?.text = days[index].time
            daySwitch?.tag = index
            daySwitch?.setOn(days[index].active, animated: true)
            checkActiveCell(days[index].active)
        default:
            print("Default")
        }
    }
    
    func checkActiveCell(_ isActive: Bool) {
        if isActive {
            dayLabel?.textColor = kColorActive
            dayTimeLabel?.textColor = kColorActive
            dayButton?.isEnabled = true
        }else {
            dayLabel?.textColor = kColorInactive
            dayTimeLabel?.textColor = kColorInactive
            dayButton?.isEnabled = false
        }
    }

}
