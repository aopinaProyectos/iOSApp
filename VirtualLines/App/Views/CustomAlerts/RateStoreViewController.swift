//
//  RateStoreViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class RateStoreViewController: PopupAlertViewController {
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    var handlerCloseView: () -> () = {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.show()
        
    }
    
    @IBAction func star1Selected() {
        star1.isSelected = true
        star2.isSelected = false
        star3.isSelected = false
        star4.isSelected = false
        star5.isSelected = false
    }
    
    @IBAction func star2Selected() {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = false
        star4.isSelected = false
        star5.isSelected = false
    }
    
    @IBAction func star3Selected() {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star4.isSelected = false
        star5.isSelected = false
    }
    
    @IBAction func star4Selected() {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star4.isSelected = true
        star5.isSelected = false
    }
    
    @IBAction func star5Selected() {
        star1.isSelected = true
        star2.isSelected = true
        star3.isSelected = true
        star4.isSelected = true
        star5.isSelected = true
    }
    
    @IBAction func closeButton(_ sender: UIButton!) {
        handlerCloseView()
        self.close()
    }
}
