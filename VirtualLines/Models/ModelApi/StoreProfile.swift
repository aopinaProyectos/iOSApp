//
//  Store.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/24/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreProfile: Mappable {
    var store: Store = Store()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        store <- map["store"]
    }
}


class Store: Mappable {
    var id: Int = 0
    var active: Int = 1
    var customerProfileId: Int = 1
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var images: [String] = []
    var preferences: [Preferences] = []
    var schedules: Schedules = Schedules()
    var storeAddress: StoreAddress = StoreAddress()
    var storeCategoryId: Int = 0
    var storeDescription: String = ""
    var webSite: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        customerProfileId <- map["customerProfileId"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        images <- map["images"]
        preferences <- map["preferences"]
        schedules <- map["schedules"]
        storeAddress <- map["storeAddress"]
        storeCategoryId <- map["storeCategoryId"]
        storeDescription <- map["storeDescription"]
        webSite <- map["webSite"]
    }
}

class Preferences: Mappable {
    var id: Int = 0
    var active: Bool = true
    var preferencesId: Int = 1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        preferencesId <- map["preferenceId"]
    }
}

class Schedules: Mappable {
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

class StoreAddress: Mappable {
    //var id: Int = 0
    //var active: Int = 0
    var country: String = ""
    var colony: String = ""
    var extNum: String = ""
    var intNum: String = ""
    var lat: Double = 0
    var lng: Double = 0
    var municipality: String = ""
    var state: String = ""
    var street: String = ""
    var zipCode: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        //id <- map["id"]
        //active <- map["active"]
        country <- map["country"]
        colony <- map["colony"]
        extNum <- map["extNum"]
        intNum <- map["intNum"]
        lat <- map["lat"]
        lng <- map["lng"]
        municipality <- map["municipality"]
        state <- map["state"]
        street <- map["street"]
        zipCode <- map["zipCode"]
    }
}


