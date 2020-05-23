//
//  menuViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/13/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kMenuOptionViewCellReuseIdentifier = "menuViewCell"

class menuViewCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionImage: UIImageView!
    
    
    func setupCell(index: Int) {
        switch index {
        case 0:
            optionImage.image = resizeImage(image: UIImage(named: "Logout")!, targetSize: CGSize(width: 30, height: 30))
            optionLabel.text = Message.LOGOUT.localized
        case 1:
            optionImage.image = resizeImage(image: UIImage(named: "Help")!, targetSize: CGSize(width: 30, height: 30))
            optionLabel.text = Message.NEEDHELP.localized
        case 2:
            optionImage.image = resizeImage(image: UIImage(named: "Terms")!, targetSize: CGSize(width: 30, height: 30))
            optionLabel.text = Message.TERMS.localized
        case 3:
            optionImage.image = resizeImage(image: UIImage(named: "Privacity")!, targetSize: CGSize(width: 30, height: 30))
            optionLabel.text = Message.PRIVACITY.localized
        case 4:
            optionImage.image = resizeImage(image: UIImage(named: "Logo")!, targetSize: CGSize(width: 30, height: 30))
            optionLabel.text = Message.ABOUT.localized
        case 5:
            optionImage.image = resizeImage(image: UIImage(named: "Logo")!, targetSize: CGSize(width: 30, height: 30))
            optionLabel.text = "Conviertete en Host"
        default:
            break
            
        }
    }
    
}
