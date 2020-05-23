//
//  LineCreated.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/21/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class LineCreated: Mappable {
    
    var id: Int = 0
    var active: Int = 0
    var maxPersons: Int = 1
    var minPersons: Int = 1
    var serviceDelay: Int = 1
    var serviceLimit: Int = 1
    var serviceTime: Int = 1
    var serviceWaitTime: Int = 1
    var userDelayTolerance: Int = 1
    var virtualLine: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        maxPersons <- map["maxPersons"]
        minPersons <- map["minPersons"]
        serviceDelay <- map["serviceDelay"]
        serviceLimit <- map["serviceLimit"]
        serviceTime <- map["serviceTime"]
        serviceWaitTime <- map["serviceWaitTime"]
        userDelayTolerance <- map["userDelayTolerance"]
        virtualLine <- map["virtualLine"]
    }
}
