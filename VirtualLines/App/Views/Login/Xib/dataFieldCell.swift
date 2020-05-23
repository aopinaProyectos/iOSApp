//
//  dataFieldCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kTableViewCellReuseIdentifier = "dataFieldCell"

protocol cellDataFieldDelegate : class {
    func validateField(sender: UITextField)
}

class dataFieldCell: UITableViewCell {
    
    @IBOutlet weak var dataField: UITextField?
    @IBOutlet weak var imageField: UIImageView?
    
    weak var cellDelegate: cellDataFieldDelegate?
    
    func setupCellProfile(index: Int, text: String) {
        setupSection()
        switch index {
        case 0:
            dataField!.attributedPlaceholder = NSAttributedString(string: Message.PHDWEBSITE.localized,
                                                             attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
            dataField?.textColor = kColorText
            //dataField?.placeholder = Message.PHDWEBSITE.localized
            dataField?.text = text
            dataField?.tag = 0
            imageField?.image = UIImage(named: "Web")
        case 1:
            dataField!.attributedPlaceholder = NSAttributedString(string: Message.PHDPHONE.localized,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
            dataField?.textColor = kColorText
            //dataField?.placeholder = Message.PHDPHONE.localized
            dataField?.text = text
            dataField?.tag = 1
            imageField?.image = UIImage(named: "Phone")
        case 2:
            dataField!.attributedPlaceholder = NSAttributedString(string: Message.PHDSTOREDESCRIPTION.localized,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: kColorInactive])
            dataField?.textColor = kColorText
            //dataField?.placeholder = Message.PHDSTOREDESCRIPTION.localized
            dataField?.text = text
            dataField?.tag = 2
            imageField?.image = UIImage(named: "Info")
        default:
            print("Default")
        }
    }
    
    func setupSection() {
        dataField?.borderWidth = 0
        dataField?.borderStyle = .none
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func validate(_ sender: UITextField) {
        cellDelegate?.validateField(sender: sender)
    }
}
