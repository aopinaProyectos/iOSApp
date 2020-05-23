//
//  Password.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class Password: Mappable {
    var passwords: Pwd = Pwd()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        passwords <- map["passwords"]
    }
}


class Pwd: Mappable {
    var currentPassword: String = ""
    var newPassword: String = ""
    var additionalProp1: String = "IeTt5LWDK4q+Ibxy1lg+TQ=="
    var additionalProp2: String = "IeTt5LWDK4q+Ibxy1ln+TQ=="
    var additionalProp3: String = "IeTt5LWDK4q+Ibxy1lr+TQ=="
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        additionalProp1 <- map["pwd1"]
        currentPassword <- map["pwd2"]
        additionalProp2 <- map["pwd3"]
        newPassword <- map["pwd4"]
        additionalProp3 <- map["pwd5"]
    }
}
