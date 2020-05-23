//
//  SignUpModel.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

enum SignUpViewModelItemType {
    case profileStore
    case schedule
}

protocol SignUpViewModelItem {
    var type : SignUpViewModelItemType { get }
    var sectionTitle : String { get }
    var rowCount : Int { get }
}

class SignUpViewModel: NSObject {
    var items = [SignUpViewModelItem] ()
    
    override init() {
        super.init()
        let profileStoreItem = SignUpViewModelProfileStoreItem(profileStore: "Profile Store")
        let scheduleItem = SignUpViewModelScheduleItem(schedule: "Schedule")
    }
}

extension SignUpViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .profileStore:
            if let item = item as? SignUpViewModelProfileStoreItem, let cell = tableView.dequeueReusableCell(withIdentifier: "dataFieldCell", for: indexPath) as? dataFieldCell{
                //cell.item = item.profileStore[indexPath.row]
                return cell
            }
        case .schedule:
            if let item = item as? SignUpViewModelProfileStoreItem, let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleViewCell", for: indexPath) as? scheduleViewCell {
                //cell.item = item.profileStore[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    
}

class SignUpViewModelProfileStoreItem: SignUpViewModelItem {
    var type: SignUpViewModelItemType {
        return .profileStore
    }
    
    var sectionTitle: String {
        return "Perfil de Establecimiento"
    }
    
    var rowCount: Int {
        return 5
    }
    
    var profileStore: String
    
    init(profileStore: String) {
        self.profileStore = profileStore
    }
}

class SignUpViewModelScheduleItem: SignUpViewModelItem {
    var type: SignUpViewModelItemType {
        return .schedule
    }
    
    var sectionTitle: String {
        return "Horarios"
    }
    
    var rowCount: Int {
        return 7
    }
    
    var schedule: String
    
    init(schedule: String) {
        self.schedule = schedule
    }
}
