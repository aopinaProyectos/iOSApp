//
//  Token.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class Token: Object, Mappable {
    
    var access_token: String = ""
    var token_type: String = ""
    var refresh_token: String = ""
    var expires_in: Int = 0
    var scopes: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        access_token <- map["access_token"]
        token_type <- map["token_type"]
        refresh_token <- map["refresh_token"]
        expires_in <- map["expires_in"]
        scopes <- map["scope"]
    }
    
    
}
