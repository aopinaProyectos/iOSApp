//
//  EmailRecover.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/22/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class EmailRecover: Object, Mappable  {
    
    var email: String = ""
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
    
}
