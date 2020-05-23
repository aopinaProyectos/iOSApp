//
//  Response.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/11/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class Response: Object, Mappable {
    
    var success: Bool = false
    var code: Int = 0
    var message: String = ""
    var status: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        status <- map["status"]
    }
    
    
}
