//
//  EmailSend.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/23/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class EmailSend: Object, Mappable {
    
    var token : String = ""
    var url : String = ""
    var response : Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        url <- map["url"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
}
