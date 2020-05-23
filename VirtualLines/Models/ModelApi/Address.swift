//
//  Address.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Address: Object, Mappable  {
    
    var id: Int = 0
    var active: Int = 0
    var country: String = ""
    var colony: String = ""
    var extNum: String = ""
    var intNum: String = ""
    var lat: Double = 0
    var lng: Double = 0
    var municipality: String = ""
    var state: String = ""
    var street: String = ""
    var zipCode: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        country <- map["country"]
        colony <- map["colony"]
        extNum <- map["extNum"]
        intNum <- map["intNum"]
        lat <- map["lat"]
        lng <- map["lng"]
        municipality <- map["municipality"]
        state <- map["state"]
        street <- map["street"]
        zipCode <- map["zipCode"]
    }
}
