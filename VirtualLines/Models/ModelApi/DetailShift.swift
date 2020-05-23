//
//  DetailShift.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/24/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class DetailShift: Object, Mappable  {
    var virtualLines: [InfoShift]?
    var virtualLine: [InfoShift]?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        virtualLines <- map["virtualLines"]
        virtualLine <- map["virtualLine"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
    
}

class virtualLine: Object, Mappable  {
    var virtualLines: [InfoLine]?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        virtualLines <- map["virtualLines"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
    
}
