//
//  CriteriaShifts.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class CriteriaShifts: Mappable {
    
    var criteria: Criteria = Criteria()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        criteria <- map["criteria"]
    }
}

class Criteria: Mappable {
    
    var day: Int = 0
    var status: [Int] = []
    var storeId: Int = 0
    var virtualLineId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        day <- map["day"]
        status <- map["status"]
        storeId <- map ["storeId"]
        virtualLineId <- map ["virtualLineId"]
    }
}
