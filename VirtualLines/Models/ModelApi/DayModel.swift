//
//  DayModel.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/25/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class DateModel {
    var dayName = ""
    
    init(dayName: String) {
        self.dayName = dayName
    }
}

class DayData: NSObject {
    
    var day: Int = 0
    var time: String = ""
    var pickerFrom: Int = 0
    var pickerTo: Int = 27
    var active: Bool = true
    
}

class ShiftRows: NSObject {
    var idStore: Int = 0
    var latitude: Double = 0
    var longitude: Double = 0
    var nameStore: String = ""
    var addresStore: String = ""
    var imageURL: String = ""
    var category: Int = 0
    var shift: String = ""
    var idShift: Int = 0
    var idLine: Int = 0
    var status: String = ""
    var shiftTime: String = ""
    var store: InfoStore = InfoStore()
    var next: Bool = false
}
