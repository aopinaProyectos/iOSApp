//
//  SearchResultsViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchResultsViewController: UITableViewController {
    
    var searchResults = [MKLocalSearchCompletion]()
    var handlerCenterMap: (MKLocalSearchCompletion) -> () = {_ in}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
            return 1
        }
        return searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let location = searchResults[indexPath.row]
        self.handlerCenterMap(location)
    }
    
}
