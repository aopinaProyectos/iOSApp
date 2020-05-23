//
//  SignUpHost.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class SignUpHost: Object, Mappable {
    
    var response: Response?
    var storeId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
        storeId <- map["storeId"]
    }
    
    
}
