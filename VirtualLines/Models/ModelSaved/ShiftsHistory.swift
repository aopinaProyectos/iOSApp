//
//  ShiftsHistory.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation

class ShiftsHistory: NSObject, NSCoding, Codable {
    
    var idStore: Int = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var nameStore: String = ""
    var addresStore: String = ""
    var imageURL: String = ""
    var category: Int = 0
    var shift: String = ""
    
    init(idStore: Int, latitude: Double, longitude: Double, nameStore: String, addresStore:String, category: Int, shift: String) {
        self.idStore = idStore
        self.latitude = latitude
        self.longitude = longitude
        self.nameStore = nameStore
        self.addresStore = addresStore
        self.category = category
        self.shift = shift
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.idStore = aDecoder.decodeInteger(forKey: "idStore")
        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
        self.longitude = aDecoder.decodeDouble(forKey: "longitude")
        self.nameStore = aDecoder.decodeObject(forKey: "nameStore") as? String ?? ""
        self.addresStore = aDecoder.decodeObject(forKey: "addresStore") as? String ?? ""
        self.category = aDecoder.decodeInteger(forKey: "category")
        self.shift = aDecoder.decodeObject(forKey: "shift") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(idStore, forKey: "idStore")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(nameStore, forKey: "nameStore")
        aCoder.encode(addresStore, forKey: "addresStore")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(shift, forKey: "shift")
    }
}
