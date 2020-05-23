//
//  ProfileStore.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/24/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ProfileStores: Object {
    
    var active: Int = 1
    var name: String = ""
    var email: String = ""
    var category: String = ""
    
}

struct store : Decodable {
    var id: Int = 0
    var active: Int = 1
    var customerProfileID: Int = 1
    var email: String = ""
    var phone: String = ""
    var storeCategoryId: Int = 0
    var storeDescription: String = ""
    var webSite: String = ""
    var preferences: [preferences]
    var schedules: schedules
    var storeAddress: storeAddress
}

struct preferences : Decodable {
    var id: Int = 0
    var preferencesId: Int = 0
    var active: Bool = true
}

struct schedules : Decodable {
    var id: Int = 0
    var monday: String = ""
    var tuesday: String = ""
    var wednesday: String = ""
    var thursday: String = ""
    var friday: String = ""
}

struct storeAddress : Decodable {
    var id: Int = 0
    var country: String = ""
    var extNum: String = ""
    var lat: Double = 0
    var lng: Double = 0
    var municipality: String = ""
    var state: String = ""
    var street: String = ""
    var zipCode: String = ""
    
}
