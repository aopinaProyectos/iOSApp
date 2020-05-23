//
//  Category.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/19/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class Category: Object, Mappable {
   
    @objc dynamic var id: Int = 0
    var active: Bool = false
    var descript: String = ""
    var name: String = ""
    var order: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        descript <- map["description"]
        name <- map["name"]
        order <- map["order"]
    }
}
