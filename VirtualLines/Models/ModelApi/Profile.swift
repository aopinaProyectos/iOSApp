//
//  Profile.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Profile: Object, Mappable  {
    
    var profileUser: ProfileUser?
    var response: Response?


    required convenience init?(map: Map){
        self.init()
    }

    func mapping(map: Map) {
        profileUser <- map["profile"]
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }

}
