//
//  InfoShift.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/24/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class InfoShift: Object, Mappable  {
    var id: Int = 0
    var name: String = ""
    var serviceTime: Int = 0
    var serviceLimit: Int = 0
    var serviceWaitTime: Int = 0
    var shifts: Int = 0
    var minNum: Int = 0
    var maxNum: Int = 0
    var shiftData: ShiftData = ShiftData()
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        serviceTime <- map["serviceTime"]
        serviceLimit <- map["serviceLimit"]
        serviceWaitTime <- map["serviceWaitTime"]
        shifts <- map["shifts"]
        minNum <- map["minNum"]
        maxNum <- map["maxNum"]
        shiftData <- map["shiftData"]
    }
    
}

class InfoLine: Object, Mappable  {
    var id: Int = 0
    var active: Int = 0
    var maxPersons: Int = 0
    var minPersons: Int = 0
    var serviceDelay: Int = 0
    var serviceLimit: Int = 0
    var serviceTime: Int = 0
    var serviceWaitTime: Int = 0
    var userDelayTolerance: Int = 0
    var virtualLine: String = ""
    
    required convenience init?(map: Map){
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
