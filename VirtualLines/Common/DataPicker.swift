//
//  Data.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/25/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation

class DataPicker {
    class func getData() -> [DateModel] {
        var data = [DateModel]()
        var datas = [DateModel]()
        var arrayString: [String] = []
        data.append(DateModel(dayName: Message.MONDAY.localized))
        data.append(DateModel(dayName: Message.TUESDAY.localized))
        data.append(DateModel(dayName: Message.WEDNESDAY.localized))
        data.append(DateModel(dayName: Message.THURSDAY.localized))
        data.append(DateModel(dayName: Message.FRIDAY.localized))
        data.append(DateModel(dayName: Message.SATURDAY.localized))
        data.append(DateModel(dayName: Message.SUNDAY.localized))
        let array = AppInfo().daysOff
        for day in array! {
            datas.append(data[Int(day)!])
            arrayString.append(data[Int(day)!].dayName)
        }
        AppInfo().daysPickerDay = arrayString
        return datas
    }
}
