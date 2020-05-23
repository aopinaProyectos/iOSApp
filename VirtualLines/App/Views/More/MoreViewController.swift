//
//  MoreViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/7/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameApp: UILabel!
    @IBOutlet weak var viewSlideImages: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.setOpaqueNavigationBar()
        self.setTitleChild("Más")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openRegisterHost.rawValue {
            let viewController = segue.destination as! RegisterHostNameViewController
            viewController.comeFromMenu = true
        }
    }
    
    private func configureSlideView(){
        
        viewSlideImages.setImageInputs([
            ImageSource(image: UIImage(named: "Banner1")!),
            ImageSource(image: UIImage(named: "Banner2")!)
            ])
        viewSlideImages.backgroundColor = UIColor.clear
        viewSlideImages.slideshowInterval = 5.0
        viewSlideImages.pageIndicatorPosition = PageIndicatorPosition.init()
        viewSlideImages.tintColor = kColorTabBar
        viewSlideImages.pageControl.pageIndicatorTintColor = UIColor.white
        viewSlideImages.contentScaleMode = UIView.ContentMode.scaleToFill
        
        viewSlideImages.currentPageChanged = { page in
            self.viewSlideImages.tag = page
        }
        
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTapSlideImage))
        //viewSlideImages.addGestureRecognizer(recognizer)
    }
    
    func setupView() {
        configureSlideView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppInfo().isUserHost ? 5 : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: kMenuOptionViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kMenuOptionViewCellReuseIdentifier)
        tableView.register(UINib(nibName: kNameMoreViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kNameMoreViewCellReuseIdentifier)
        /*if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameMoreViewCell") as! nameMoreViewCell
            cell.setupView()
            return cell
        }*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell") as! menuViewCell
        cell.setupCell(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            logout()
        case 1:
            help()
        case 2:
            goToPage()
        case 3:
            goToPage()
        case 4:
            goToPage()
        case 5:
            self.performSegue(withIdentifier: SeguesIdentifiers.openRegisterHost.rawValue, sender: self)
        default:
            break
        }
    }
    
    func logout() {
        AppInfo().userName = ""
        AppInfo().password = ""
        removeData()
        UIStoryboard.loadLogin()
    }
    
    func help() {
        print ("Help")
    }
    
    func goToPage() {
        print ("GotoPage")
    }
    
    func removeData() {
        let addressArray: [AddressUser] = []
        AppInfo().isUserHost = false
        let placesData = try! JSONEncoder().encode(addressArray)
        UserDefaults.standard.set(placesData, forKey: "address")
    }



}

/*class MoreViewController: PopupAlertViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAd: UIImageView!
    @IBOutlet weak var greetings: UILabel!
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView!.register(UINib(nibName: kMenuOptionViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kMenuOptionViewCellReuseIdentifier)
    }
    
    func logout() {
        AppInfo().userName = ""
        AppInfo().password = ""
        UIStoryboard.loadLogin()
    }
    
    func help() {
        print ("Help")
    }
    
    func goToPage() {
        print ("GotoPage")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell") as! menuViewCell
        cell.setupCell(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            logout()
        case 1:
            help()
        case 2:
            goToPage()
        case 3:
            goToPage()
        case 4:
            goToPage()
        default:
            break
        }
    }
}*/
