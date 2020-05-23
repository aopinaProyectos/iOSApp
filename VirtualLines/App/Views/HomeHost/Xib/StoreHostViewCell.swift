//
//  StoreHostViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kStoreHostViewCellReuseIdentifier = "StoreHostViewCell"

protocol editButtonProfileDelegate : class {
    func editButton(sender: UIButton)
}

class StoreHostViewCell: UITableViewCell {
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var nameStoreLabel: UILabel!
    @IBOutlet weak var addressStoreLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    weak var cellDelegate: editButtonProfileDelegate?
    
    func setupView(store: StoreDetail) {
        storeImage.image = UIImage(named: "Restaurants")
        nameStoreLabel.text = store.name
        addressStoreLabel.text = store.storeAddress?.street
        let image = resizeImage(image: UIImage(named: "Edit")!, targetSize: CGSize(width: 25, height: 25))
        editButton.setImage(image.tinted(with: kColorActive), for: .normal)
    }
    
    @IBAction func buttonEdit(sender: UIButton) {
        cellDelegate!.editButton(sender: sender)
    }
    
}
