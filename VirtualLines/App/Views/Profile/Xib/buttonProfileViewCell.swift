//
//  buttonProfileViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/2/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kButtonProfileViewCellReuseIdentifier = "buttonProfileViewCell"

protocol cellButtonProfileDelegate : class {
    func pressSave(sender: UIButton)
}

class buttonProfileViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonSave: UIButton!
    
    weak var cellDelegate: cellButtonProfileDelegate?
    
    func setupView() {
        buttonSave.backgroundColor = kColorButtonActive
        buttonSave.setTitleColor(UIColor.white, for: .normal)
        buttonSave.setTitle(Message.SAVE.localized, for: .normal)
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        cellDelegate?.pressSave(sender: sender)
    }
}
