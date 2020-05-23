//
//  emptyDataShiftHostViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/19/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kEmptyDataShiftHostViewCellReuseIdentifier = "emptyDataShiftHostViewCell"

class emptyDataShiftHostViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emptyImage: UIImageView!
    
    func setupView(){
        messageLabel.textColor = kColorInactive
        emptyImage.image = emptyImage.image?.tinted(with: kColorInactive)
    }
    
    
    
}
