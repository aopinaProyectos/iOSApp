//
//  AddressUser.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/27/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class UserAddress: Object, Mappable  {
    var locations: [Locations]?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        locations <- map["locations"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
    
}

class Locations: Object, Mappable {
    
    var id: Int = 0
    var active: Int = 0
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
