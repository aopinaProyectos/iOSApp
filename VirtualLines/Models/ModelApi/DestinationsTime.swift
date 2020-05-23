//
//  DestinationsTime.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class DirectionsTime: Object, Mappable {
    var response: Response?
    var data: [DataDirectionsTime] = [DataDirectionsTime]()
    
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


class DataDirectionsTime: Object, Mappable {
    var distance: String = ""
    var duration: String = ""
    var storeId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        duration <- map["duration"]
        storeId <- map["storeId"]
    }
}

