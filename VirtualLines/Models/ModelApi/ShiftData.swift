//
//  ShiftData.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/14/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper
import RealmSwift

class ShiftData: Object, Mappable  {
    var id: Int = 0
    var storeId: String = ""
    var virtualLineId: Int = 0
    var shift: Int = 0
    var shiftDate: Int = 0
    var shiftTime: Int = 0
    var shiftDateTime: Int = 0
    var status: Int = 0
    var statusText: String = ""
    var urlQRCode: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        storeId <- map["storeId"]
        virtualLineId <- map["virtualLineId"]
        shift <- map["shift"]
        shiftDate <- map["shiftDate"]
        shiftTime <- map["shiftTime"]
        shiftDateTime <- map["shiftDateTime"]
        status <- map["status"]
        statusText <- map["status"]
        urlQRCode <- map["urlQRCode"]
    }
    
}

class ShiftDataString: Object, Mappable  {
    var id: Int = 0
    var storeId: String = ""
    var virtualLineId: Int = 0
    var shift: String = ""
    var shiftDate: Int = 0
    var shiftTime: String = ""
    var shiftDateTime: Int = 0
    var status: String = ""
    var statusText: String = ""
    var urlQRCode: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        storeId <- map["storeId"]
        virtualLineId <- map["virtualLineId"]
        shift <- map["shift"]
        shiftDate <- map["shiftDate"]
        shiftTime <- map["shiftTime"]
        shiftDateTime <- map["shiftDateTime"]
        status <- map["status"]
        statusText <- map["status"]
        urlQRCode <- map["urlQRCode"]
    }
    
}



