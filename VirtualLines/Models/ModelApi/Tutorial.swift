//
//  Tutorial.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/10/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper
import RealmSwift

class Intro: Object, Mappable  {
    var intro: [Tutorial]?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        intro <- map["intro"]
    }
    
}

class Tutorial: Object, Mappable  {
    var image: String = ""
    var text: String = ""
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        text <- map["text"]
    }
    
}
