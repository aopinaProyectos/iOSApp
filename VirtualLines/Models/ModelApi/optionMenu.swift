//
//  optionMenu.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

enum optionMenuSection:Int {
    case enterteinment
    case health
    case banks
    case restaurants
    case pets
    case education
}

class optionMenu {
    var title : String?
    var image : UIImage?
    var section : String?
    
    init(title: String, image: UIImage, section: String) {
        self.title = title
        self.image = image
        self.section = section
    }
}
