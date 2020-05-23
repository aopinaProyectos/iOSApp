//
//  dataProfileViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kDataProfileViewCellReuseIdentifier = "dataProfileViewCell"

protocol cellTextFieldProfileDelegate : class {
    func getData(sender: UITextField)
}

class dataProfileViewCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UITextField!
    
    weak var cellDelegate: cellTextFieldProfileDelegate?
    
    func setupView(section: Int, row: Int, text: String) {
        self.placeholderLabel.borderStyle = .none
        self.placeholderLabel.borderWidth = 0
        titleLabel.textColor = kColorText
        placeholderLabel.textColor = kColorActive
        switch section {
        case 0:
            switch row {
            case 0:
                titleLabel.text = Message.NAMECELL.localized
                placeholderLabel.text = text
                placeholderLabel.placeholder = Message.PHDNAME.localized
                if text != "" {
                    placeholderLabel.text = text
                }else {
                    placeholderLabel.placeholder = Message.PHDNAME.localized
                }
            case 1:
                titleLabel.text = Message.EMAILCELL.localized
                if text != "" {
                    placeholderLabel.text = text
                }else {
                    placeholderLabel.placeholder = Message.PHDEMAIL.localized
                }
            /*case 2:
                titleLabel.text = Message.PHONECELL.localized
                if text != "" {
                    placeholderLabel.text = text
                }else {
                    placeholderLabel.placeholder = Message.PHDPHONE.localized
                }*/
            case 2:
                titleLabel.text = Message.GENDERCELL.localized
                if text != "" {
                    placeholderLabel.text = text
                }else {
                    placeholderLabel.placeholder = Message.PHDPHONE.localized
                }
            case 3:
                placeholderLabel.tag = 5
                placeholderLabel.text = text
                placeholderLabel.placeholder = Message.PHDBIRTHDATE.localized
            default:
                break
            }
        case 2:
            switch row {
            case 0:
                placeholderLabel.tag = 6
                titleLabel.text = Message.PASSWORDBEFORE.localized
                placeholderLabel.placeholder = Message.PHDOLDPWD.localized
            case 1:
                placeholderLabel.tag = 7
                titleLabel.text = Message.PASSWORDNOW.localized
                placeholderLabel.placeholder = Message.PHDNEWPWD.localized
            default:
                break
            }
        default:
            break
        }
    }
    
    @IBAction func textEdit(sender: UITextField) {
        cellDelegate!.getData(sender: sender)
    }
    
}
