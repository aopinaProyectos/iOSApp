//
//  UpdateShift.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class UpdateShift: Object, Mappable  {
    var delay: Int = 0
    var next: Bool = false
    var shift: Shift?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        delay <- map["delay"]
        next <- map["next"]
        shift <- map["nextShift"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
    
}
