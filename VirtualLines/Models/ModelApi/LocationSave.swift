//
//  Locations.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/27/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class LocationSave: Mappable {
    
    var id: Int = 0
    var active: Int = 1
    var lat: Double = 0
    var lng: Double = 0
    var name: String = ""
    var phoneNumber: String = ""
    var selected: Bool = true
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        lat <- map["lat"]
        lng <- map["lng"]
        name <- map["name"]
        phoneNumber <- map["phoneNumber"]
        selected <- map["selected"]
    }
}
