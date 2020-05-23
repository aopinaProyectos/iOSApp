//
//  ShiftNewTurn.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class ShiftNewTurn: Mappable {
    
    //var minutes: Int = 0
    var phoneNumber: String = ""
    var storeId: Int = 0
    var virtualLineId: Int = 0
    var totalPersons: Int = 1
    var shiftDateTime: Int = 20190702
    var nextLine: Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //minutes <- map["minutes"]
        phoneNumber <- map["phoneNumber"]
        storeId <- map ["storeId"]
        virtualLineId <- map ["virtualLineId"]
        totalPersons <- map["totalPersons"]
        shiftDateTime <- map["shiftDateTime"]
        nextLine <- map["nextLine"]
    }
}
