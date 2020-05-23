//
//  Categories.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/24/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Categories: Object, Mappable {
    
    var response : Response?
    
    var categories: [Category]? = []
    
    required convenience init?(map: Map){
        self.init()
    }
    
    
    func mapping(map: Map) {
        var categories : [Category]?
        categories <- map["categories"]
        if let categories = categories?.sorted(by: {$1.order > $0.order}) {
            for categ in categories {
                self.categories?.append(categ)
                //self.categories.append(categ)
            }
        }
        if let json = map["response"].currentValue, let mapJson = json as? [String : Any] {
            response = Mapper<Response>().map(JSON: mapJson)
        }
    }
}
