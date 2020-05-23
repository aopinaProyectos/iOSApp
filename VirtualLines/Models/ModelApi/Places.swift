//
//  Places.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Places: Object, Mappable  {
    var places: [DataStore]?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        //var placeString: String = ""
        places <- map["places"]
        //places = Mapper<DataStore>().mapArray(JSONString: placeString)
        
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
}
