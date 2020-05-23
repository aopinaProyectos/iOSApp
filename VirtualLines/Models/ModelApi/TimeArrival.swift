//
//  TimeArrival.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class TimeArrival: Mappable {
    var origin: Origin = Origin()
    var destination: [DestinationTime] = [DestinationTime]()
    var tripMode: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        tripMode <- map["tripMode"]
        origin <- map["origin"]
        destination <- map ["destinations"]
    }
}

class DestinationTime: Mappable {
    var destination: Destination = Destination()
    var storeId: Int = 0
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        destination <- map["destination"]
        storeId <- map["storeId"]
    }
}
