//
//  storeHeaderCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kStoreHeaderCellReuseIdentifier = "storeHeaderCell"

class storeHeaderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupView(title: String) {
        titleLabel.text = title
    }
}
