//
//  StoresHostViewControllers.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class StoresHostViewControllers: UIViewController, UITableViewDelegate, UITableViewDataSource, editButtonProfileDelegate {
    
    var stores: [StoreDetail] = [StoreDetail]()
    var tag: Int = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: kStoreHostViewCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kStoreHostViewCellReuseIdentifier)
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.openProfileHost.rawValue {
            let viewController = segue.destination as! ProfileHostViewController
            viewController.id = stores[tag].id
        }
    }
    
    func editButton(sender: UIButton) {
        tag = sender.tag
        self.performSegue(withIdentifier: SeguesIdentifiers.openProfileHost.rawValue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: "StoreHostViewCell") as! StoreHostViewCell
        cellDefault.cellDelegate = self
        cellDefault.editButton.tag = indexPath.row
        cellDefault.setupView(store: stores[indexPath.row])
        return cellDefault
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppInfo().storeIdSelectedHost = indexPath.row + 1
        UIStoryboard.loadMenuHost()
    }
}
