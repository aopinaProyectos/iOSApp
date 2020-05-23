//
//  Profile.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ProfileUser: Object, Mappable  {
    
    var id: Int = 0
    var active: Int = 0
    var birthdate: String = ""
    var customerType: Int = 0
    var email: String = ""
    var firstName: String = ""
    var gender: String = ""
    var language: String = ""
    var password: String = ""
    var phone: String = ""
    var picture: String = ""
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        active <- map["active"]
        birthdate <- map["birthdate"]
        customerType <- map["customerType"]
        email <- map["email"]
        firstName <- map["firstName"]
        gender <- map["gender"]
        language <- map["language"]
        password <- map["password"]
        phone <- map["phone"]
        picture <- map["picture"]
    }
}
