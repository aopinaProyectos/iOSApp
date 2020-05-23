//
//  Login.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/22/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Login: Object, Mappable  {
    
    var category: Int = 0
    var globalMsg: String = ""
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        category <- map["category"]
        globalMsg <- map["globalMsg"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
}

