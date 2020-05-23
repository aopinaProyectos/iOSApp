//
//  Directions.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/15/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Directions: Object, Mappable {
    var response: Response?
    var data: Rote?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
}


class Rote: Object, Mappable {
    var route1: [String] = []
    var route2: [String] = []
    var route3: [String] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        route1 <- map["route1"]
        route2 <- map["route2"]
        route3 <- map["route3"]
    }
}

