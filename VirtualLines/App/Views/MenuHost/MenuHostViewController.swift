//
//  MenuHostViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import SwipeableTabBarController
import SideMenu


enum menuSectionHost : Int {
    case favorite = 0
    case myRows = 1
    case homeHost = 2
    case home = 3
    case more = 4
}

class MenuHostViewController: SwipeableTabBarController {
    
    let middleButton = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        //setupBar()
        //self.orderingTabBar()
        selectedViewController = viewControllers?[2]
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.3621281683, green: 0.3621373773, blue: 0.3621324301, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.3111690581, green: 0.5590575933, blue: 0.8019174337, alpha: 1)
        self.tabBar.isHidden = true
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        //self.tabBar.itemSpacing = UIScreen.main.bounds.width / 2
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //setupBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.tabBar.itemSpacing = UIScreen.main.bounds.width / 5
        //self.tabBar.itemPositioning = .centered
    }
    
    func loadSection(section: menuSectionHost) {
        loadController(navigation: self, section: section)
    }
    
    func setupTabBar() {
        viewControllers![0].tabBarItem.image = self.resizeImage(image: UIImage(named: "Favorites")!, targetSize: CGSize(width: 35, height: 35))
        viewControllers![0].tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        viewControllers![1].tabBarItem.image = self.resizeImage(image: UIImage(named: "MyRows")!, targetSize: CGSize(width: 35, height: 35))
        viewControllers![1].tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        viewControllers![2].tabBarItem.image = self.resizeImage(image: UIImage(named: "Business")!, targetSize: CGSize(width: 35, height: 35))
        viewControllers![2].tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        viewControllers![3].tabBarItem.image = self.resizeImage(image: UIImage(named: "StoreTB")!, targetSize: CGSize(width: 35, height: 35))
        viewControllers![3].tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        viewControllers![4].tabBarItem.image = self.resizeImage(image: UIImage(named: "More")!, targetSize: CGSize(width: 35, height: 35))
        viewControllers![4].tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
    }
    
    func setupBar(){
        let imageOrigin = self.resizeImage(image: UIImage(named: "Business")!, targetSize: CGSize(width: 45, height: 45))
        let image = imageOrigin.tinted(with: #colorLiteral(red: 0.3621281683, green: 0.3621373773, blue: 0.3621324301, alpha: 1))
        let imageSelect = imageOrigin.tinted(with: #colorLiteral(red: 0.3111690581, green: 0.5590575933, blue: 0.8019174337, alpha: 1))
        middleButton.setImage(image, for: .normal)
        middleButton.setImage(imageSelect, for: .selected)
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = UIColor.white
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 10)
        middleButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.tabBar.addSubview(middleButton)
        self.tabBar.centerXAnchor.constraint(equalTo: middleButton.centerXAnchor).isActive = true
        self.tabBar.topAnchor.constraint(equalTo: middleButton.centerYAnchor).isActive = true
        middleButton.isSelected = true
    }
    
    @objc func buttonAction() {
        middleButton.isSelected = true
        self.tabBarController?.selectedIndex = 2
    }
    
    func orderingTabBar() {
        if let views = self.viewControllers {
            var barViewControllers: [UIViewController] = []
            var countViews = views.count
            for view in views {
                barViewControllers.insert(view, at: countViews - 1)
                countViews = countViews - 1
            }
            self.viewControllers = barViewControllers
        }
    }
    
    func tabBarcontroller(_ tabBarController: UITabBarController, didselect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            showViewControllerTitle(title: "Prueba")
        case 1:
            showViewControllerTitle(title: "Prueba")
        case 2:
            showViewControllerTitle(title: "Prueba")
        case 3:
            showViewControllerTitle(title: "Prueba")
        case 4:
            showViewControllerTitle(title: "Prueba")
        default:
            return
            
        }
    }
    
    func showViewControllerTitle(title: String) {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



//MARK: Routable Views
protocol RoutableHost {
    associatedtype T
    func loadController<T: UITabBarController>(navigation: T, section: menuSectionHost)
}

extension MenuHostViewController: RoutableHost {
    typealias T = UITabBarController
}

extension RoutableHost {
    func loadController<T: UITabBarController>(navigation: T, section: menuSectionHost) {
        navigation.selectedIndex = section.rawValue
        navigation.selectedViewController = navigation.viewControllers?[section.rawValue]
    }
}
