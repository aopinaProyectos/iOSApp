//
//  Slide.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/1/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import UIKit

class Slide1: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var constraintHeightView1: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightView2: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightImage: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthImage: NSLayoutConstraint!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewText: UIView!
    
    func setupView(height: CGFloat) {
        viewImage.backgroundColor = kColorTuBackground
        constraintHeightView1.constant = height / 2
        constraintHeightView2.constant = height / 2
        if AppInfo().screenHeigth < 660 {
            label1.font = label1.font.withSize(kSFontIpSETuLabel)
        }else if AppInfo().screenHeigth < 736 {
            constraintHeightImage.constant = constraintHeightImage.constant + 250
            constraintWidthImage.constant = constraintWidthImage.constant + 80
        }
    }

}
