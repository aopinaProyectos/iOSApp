//
//  Routes.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/15/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class Routes: Mappable {
    var origin: Origin = Origin()
    var destination: Destination = Destination()
    var tripMode: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        tripMode <- map["tripMode"]
        origin <- map["origin"]
        destination <- map ["destination"]
    }
}

class Origin: Mappable {
    var lat: Double = 0
    var lng: Double = 0
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}

class Destination: Mappable {
    var lat: Double = 0
    var lng: Double = 0
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}




