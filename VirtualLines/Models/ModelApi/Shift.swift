//
//  Shift.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Shift: Object, Mappable  {
    var id: Int = 0
    var shift: String = ""
    var shiftDate: Int = 0
    var shiftDateTime: Int = 0
    var shiftTime: String = ""
    var status: String = ""
    var storeId: Int = 0
    var totalPerson: Int = 0
    var totalPersons: Int = 0
    var urlQRCode: String = ""
    var userId: Int = 0
    var virtualLineId: Int = 0
    var virtualLineName: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        shift <- map["shift"]
        shiftDate <- map["shiftDate"]
        shiftDateTime <- map["shiftDateTime"]
        shiftTime <- map["shiftTime"]
        status <- map["status"]
        storeId <- map["storeId"]
        totalPerson <- map["totalPerson"]
        totalPersons <- map["totalPersons"]
        urlQRCode <- map["urlQRCode"]
        userId <- map["userId"]
        virtualLineId <- map["virtualLineId"]
        virtualLineName <- map["virtualLineName"]
    }
}
