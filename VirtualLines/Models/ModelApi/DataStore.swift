//
//  DataStore.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class DataStore: Object, Mappable  {
    
    var distance: Int = 0
    var storeDetail: StoreDetail?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        if let json = map["store"].currentValue, let mapJson = json as? [String : Any] {
            storeDetail = Mapper<StoreDetail>().map(JSON: mapJson)
        }
    }
}
