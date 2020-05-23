//
//  aboutViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/15/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kAboutViewCellReuseIdentifier = "aboutViewCell"

protocol cellAboutDelegate : class {
    func validateButton(_ sender: UIButton)
}

class aboutViewCell: UITableViewCell {
    
    @IBOutlet weak var petButton: UIButton!
    @IBOutlet weak var smokeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var petLabel: UILabel!
    @IBOutlet weak var smokeLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    
    weak var cellDelegate: cellAboutDelegate?
    
    func setupCell() {
        petLabel.isHidden = petButton.isSelected
        smokeLabel.isHidden = smokeButton.isSelected
        shareLabel.isHidden = shareButton.isSelected
        let imagePet = UIImage(named: "PetUns")
        let imageSmoke = UIImage(named: "SmokeUns")
        let imageShare = UIImage(named: "MeetUns")
        petButton.setImage(imagePet?.tinted(with: kColorText), for: .normal)
        smokeButton.setImage(imageSmoke?.tinted(with: kColorText), for: .normal)
        shareButton.setImage(imageShare?.tinted(with: kColorText), for: .normal)
    }
    
    func scaleButtonPet() {
        self.petButton.isSelected = !self.petButton.isSelected
        if self.petButton.isSelected {
            UIView.animate(withDuration: 0.5, animations: {
                self.petButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.petLabel.isHidden = false
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.petButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.petLabel.isHidden = true
            })
        }
    }
    
    func scaleButtonSmoke() {
        self.smokeButton.isSelected = !self.smokeButton.isSelected
        if self.smokeButton.isSelected {
            UIView.animate(withDuration: 0.5, animations: {
                self.smokeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.smokeLabel.isHidden = false
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.smokeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.smokeLabel.isHidden = true
            })
        }
    }
    
    func scaleButtonShare() {
        self.shareButton.isSelected = !self.shareButton.isSelected
        if self.shareButton.isSelected {
            UIView.animate(withDuration: 0.5, animations: {
                self.shareButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.shareLabel.isHidden = false
            })
        }else {
            UIView.animate(withDuration: 0.5, animations: {
                self.shareButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.shareLabel.isHidden = true
            })
        }
        
    }
    
    @IBAction func validate(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            scaleButtonSmoke()
        case 1:
            scaleButtonPet()
        case 2:
            scaleButtonShare()
        default:
            break
        }
        cellDelegate?.validateButton(sender)
    }
    
}
