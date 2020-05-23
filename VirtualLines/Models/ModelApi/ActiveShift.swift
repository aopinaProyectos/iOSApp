//
//  ActiveShift.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ActiveShift: Object, Mappable  {
    var shift: [Shift]?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        shift <- map["shifts"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
    
}
