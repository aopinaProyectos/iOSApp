//
//  StoreDetail.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class StoreDetail: Object, Mappable  {
    
    var id: Int = 0
    var active: Int = 1
    var customerProfileId: Int = 1
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var images: [images] = []
    var preferences: [Preferences] = []
    var schedules: Sched = Sched()
    var storeAddress: Address?
    var storeCategoryId: Int = 0
    var storeDescription: String = ""
    var storeRating: Int = 0
    var webSite: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        customerProfileId <- map["customerProfileId"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        if map["images"] == nil {
            images = []
        } else {
            images <- map["images"]
        }
        preferences <- map["preferences"]
        schedules <- map["schedules"]
        //storeAddress <- map["storeAddress"]
        if let json = map["storeAddress"].currentValue, let mapJson = json as? [String : Any] {
            storeAddress = Mapper<Address>().map(JSON: mapJson)
        }
        storeCategoryId <- map["storeCategoryId"]
        storeDescription <- map["storeDescription"]
        storeRating <- map["storeRating"]
        webSite <- map["webSite"]
    }
}

class Sched: Object, Mappable {
    var id: Int = 0
    var monday: String = ""
    var tuesday: String = ""
    var wednesday: String = ""
    var thursday: String = ""
    var friday: String = ""
    var saturday: String = ""
    var sunday: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        monday <- map["monday"]
        tuesday <- map["tuesday"]
        wednesday <- map["wednesday"]
        thursday <- map["thursday"]
        friday <- map["friday"]
        saturday <- map["saturday"]
        sunday <- map["sunday"]
    }
}

class images: Object, Mappable {
    var id: Int = 0
    var url: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
    }
}
