//
//  ManageShift.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ManageShift: Object, Mappable  {
    var stores: [ShiftsDetail]?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        stores <- map["store"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
    
}

class ShiftsDetail: Object, Mappable  {
    var shiftData: ShiftDataString?
    var userContactInfo: UserContactInfo?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        shiftData <- map["shiftData"]
        userContactInfo <- map["userContactInfo"]
    }
    
}

class UserContactInfo: Object, Mappable  {
    var id: Int = 0
    var name: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}
