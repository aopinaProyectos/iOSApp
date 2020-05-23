//
//  Fav.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/6/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper

class Favorites: Mappable {
    var favorites: Fav = Fav()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        favorites <- map["favorite"]
    }
}

class Fav: Mappable {
    var status: Bool = true
    var storeId: Int = 0
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        storeId <- map["storeId"]
    }
}
