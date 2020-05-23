//
//  CustomTabBarViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    internal func hideTabBar(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    internal func showTabBar(){
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
