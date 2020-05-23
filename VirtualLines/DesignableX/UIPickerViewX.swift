//
//  UIPickerViewX.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/25/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class UIPickerViewX: UIPickerView {
    
    @IBInspectable var horizontal: Bool = false {
        didSet {
            updateView()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        updateView()
    }
    
    
    func updateView() {
        if horizontal {
            transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        } else {
            transform = .identity
        }
    }
}
