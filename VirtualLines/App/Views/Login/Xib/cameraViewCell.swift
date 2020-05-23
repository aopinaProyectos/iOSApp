//
//  cameraViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kCameraCellReuseIdentifier = "cameraViewCell"

protocol cameraViewCellDelegate: class {
    func cameraTapped(_ tag: Int)
}

class cameraViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonCamera: UIButton?
    @IBOutlet weak var labelIntructions: UILabel?
    
    weak var cellDelegate: cameraViewCellDelegate?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        cellDelegate?.cameraTapped(sender.tag)
    }
    
    
}

