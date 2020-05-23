//
//  InfoStore.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/2/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class InfoStore: Object, Mappable  {
    var store: StoreDetail?
    var response: Response?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        store <- map["store"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
}
