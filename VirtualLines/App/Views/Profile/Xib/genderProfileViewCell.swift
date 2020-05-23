//
//  genderProfileViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kGenderProfileViewCellReuseIdentifier = "genderProfileViewCell"

protocol cellGenderProfileDelegate : class {
    func pressMale(sender: UIButton)
    func pressFemale(sender: UIButton)
}

class genderProfileViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonMale: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    
    weak var cellDelegate: cellGenderProfileDelegate?
    
    func setupView(text: String) {
        if text == "M" {
            self.buttonMale.isSelected = true
            self.buttonMale.borderColor = kColorButtonActive
            self.buttonMale.backgroundColor = kColorButtonActive
            self.buttonMale.titleLabel?.textColor = UIColor.white
            self.buttonFemale.isSelected = false
            self.buttonFemale.borderColor = kColorButtonActive
            self.buttonFemale.backgroundColor = UIColor.white
            self.buttonFemale.titleLabel?.textColor = kColorButtonActive
        }else if text == "F" {
            self.buttonMale.isSelected = false
            self.buttonMale.borderColor = kColorButtonActive
            self.buttonMale.backgroundColor = UIColor.white
            self.buttonMale.titleLabel?.textColor = kColorButtonActive
            self.buttonFemale.isSelected = true
            self.buttonFemale.borderColor = kColorButtonActive
            self.buttonFemale.backgroundColor = kColorButtonActive
            self.buttonFemale.titleLabel?.textColor = UIColor.white
        }else {
            self.buttonMale.isSelected = false
            self.buttonMale.borderColor = kColorButtonActive
            self.buttonMale.backgroundColor = UIColor.white
            self.buttonMale.titleLabel?.textColor = kColorButtonActive
            self.buttonFemale.isSelected = false
            self.buttonFemale.borderColor = kColorButtonActive
            self.buttonFemale.backgroundColor = UIColor.white
            self.buttonFemale.titleLabel?.textColor = kColorButtonActive
        }
    }
    
    @IBAction func maleButtonPressed(sender: UIButton) {
        self.buttonMale.isSelected = !(self.buttonMale.isSelected)
        self.buttonFemale.isSelected = !(self.buttonMale.isSelected)
        if self.buttonFemale.isSelected == true {
            self.buttonFemale.borderColor = kColorButtonActive
            self.buttonFemale.backgroundColor = kColorButtonActive
            self.buttonFemale.titleLabel?.textColor = UIColor.white
        } else {
            self.buttonFemale.borderColor = kColorButtonActive
            self.buttonFemale.backgroundColor = UIColor.white
            self.buttonFemale.titleLabel?.textColor = kColorButtonActive
        }
        if self.buttonMale.isSelected == true {
            self.buttonMale.borderColor = kColorButtonActive
            self.buttonMale.backgroundColor = kColorButtonActive
            self.buttonMale.titleLabel?.textColor = UIColor.white
        } else {
            self.buttonMale.borderColor = kColorButtonActive
            self.buttonMale.backgroundColor = UIColor.white
            self.buttonMale.titleLabel?.textColor = kColorButtonActive
        }
        cellDelegate?.pressMale(sender: sender)
    }
    
    @IBAction func femaleButtonPressed(sender: UIButton) {
        self.buttonFemale.isSelected = !(self.buttonFemale.isSelected)
        self.buttonMale.isSelected = !(self.buttonFemale.isSelected)
        if self.buttonFemale.isSelected == true {
            self.buttonFemale.borderColor = kColorButtonActive
            self.buttonFemale.backgroundColor = kColorButtonActive
            self.buttonFemale.titleLabel?.textColor = UIColor.white
        } else {
            self.buttonFemale.borderColor = kColorButtonActive
            self.buttonFemale.backgroundColor = UIColor.white
            self.buttonFemale.titleLabel?.textColor = kColorButtonActive
        }
        if self.buttonMale.isSelected == true {
            self.buttonMale.borderColor = kColorButtonActive
            self.buttonMale.backgroundColor = kColorButtonActive
            self.buttonMale.titleLabel?.textColor = UIColor.white
        } else {
            self.buttonMale.borderColor = kColorButtonActive
            self.buttonMale.backgroundColor = UIColor.white
            self.buttonMale.titleLabel?.textColor = kColorButtonActive
        }
        cellDelegate?.pressFemale(sender: sender)
    }
}
