//
//  birthdateProfileViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kBirthProfileViewCellReuseIdentifier = "birthProfileViewCell"

protocol cellBirthProfileDelegate : class {
    func datePicker(sender: UIButton)
}

class birthProfileViewCell: UITableViewCell {
    
    @IBOutlet weak var birthdate: UIButton!
    
    weak var cellDelegate: cellBirthProfileDelegate?
    
    func setupView(text: String) {
        if text != "" {
            self.birthdate.setTitle(text, for: .normal)
            self.birthdate.setTitleColor(kColorActive, for: .normal)
        }else {
            self.birthdate.setTitle("Ingresa tu fecha de Nacimiento", for: .normal)
            self.birthdate.setTitleColor(kColorActive, for: .normal)
        }
    }
    
    @IBAction func birthButtonPressed(sender: UIButton) {
        cellDelegate?.datePicker(sender: sender)
    }
}
