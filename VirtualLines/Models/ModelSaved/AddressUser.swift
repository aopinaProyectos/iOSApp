//
//  AddressUser.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/24/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation

class AddressUser: NSObject, NSCoding, Codable {
    
    var id: Int = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var name: String
    var address: String
    var active: Bool
    
    init(id: Int, latitude: Double, longitude: Double, name: String, address: String, active: Bool) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.address = address
        self.active = active
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
        self.longitude = aDecoder.decodeDouble(forKey: "longitude")
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        self.active = aDecoder.decodeBool(forKey: "active")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(active, forKey: "active")
    }
}
