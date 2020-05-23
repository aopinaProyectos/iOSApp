//
//  CustomPicker.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/25/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class DateModelPicker: NSObject {
    var modelData: [DateModel]!
    var rotationAngle: CGFloat!
    
    override init() {
        modelData = DataPicker.getData()
    }
}

extension DateModelPicker: UIPickerViewDataSource {
    // Like number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modelData.count
    }
}

extension DateModelPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        
        let textColor = kColorActive
        
        let topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        topLabel.text = modelData[row].dayName
        topLabel.textColor = textColor
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        view.addSubview(topLabel)
        
        view.transform = CGAffineTransform(rotationAngle: (90 * (.pi/180)))
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //AppInfo().dayPicker = row
        AppInfo().dayPickerSelect = modelData[row].dayName
        NotificationCenter.default.post(name: .pickChanged, object: self)
    }
}
