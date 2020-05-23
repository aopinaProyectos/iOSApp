//
//  CustomPickerSchedViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/25/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class CustomPickerSchedViewController : PopupAlertViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var instructionsLabel: UILabel?
    @IBOutlet weak var saveButton: UIButton?
    @IBOutlet weak var toPicker: UIPickerView?
    @IBOutlet weak var fromPicker: UIPickerView?
    @IBOutlet weak var dayPicker: UIPickerView?
    //@IBOutlet weak var dayPicker:
    
    var rotationAngle: CGFloat!
    var dateModelPicker: DateModelPicker!
    var pickerData: [String] = [String]()
    var pickerDataFrom: [String] = [String]()
    var pickerDataTo: [String] = [String]()
    var handlerCloseView: () -> () = {}
    var days: [DayData] = [DayData]()
    var datas = DayData()
    var dayPickerSelected: Int = 0
    
    var rowFrom = 0
    var rowTo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(pickChanged), name: .pickChanged, object: nil)
        setupPickerDay()
        setupView()
        rotationAngle = -(90 * (.pi/180))
        let y = dayPicker?.frame.origin.y
        dayPicker?.transform = CGAffineTransform(rotationAngle: rotationAngle)
        dayPicker?.frame = CGRect(x: -120, y: y!, width: view.frame.width + 200, height: 40)
        
        dateModelPicker = DateModelPicker()
        dateModelPicker.rotationAngle = rotationAngle
        
        dayPicker?.delegate = dateModelPicker
        dayPicker?.dataSource = dateModelPicker
        dayPicker?.selectRow(3, inComponent: 0, animated: true)
        
        fromPicker?.delegate = self
        fromPicker?.dataSource = self
        
        toPicker?.delegate = self
        toPicker?.dataSource = self
        
        getIndex(AppInfo().dayPickerSelect)
        setupArray()
        setupPicker()
        rowFrom = 0
        rowTo = pickerDataTo.count - 1
    }
    
    func setupView() {
        getIntervals(start: kTimeStart, end: kTimeEnd)
    }
    
    func setupPickerDay() {
        var dayArray: [String] = []
        AppInfo().daysOff?.removeAll()
        for day in days {
            if day.active == true {
                dayArray.append(String(day.day))
            }
        }
        AppInfo().daysOff = dayArray
    }
    
    func setupPicker() {
        dayPicker?.selectRow(dayPickerSelected, inComponent: 0, animated: true)
        dayPicker?.reloadAllComponents()
        checkDays()
        fromPicker?.selectRow(days[AppInfo().dayPicker].pickerFrom, inComponent: 0, animated: true)
        fromPicker?.reloadAllComponents()
        
        toPicker?.selectRow(days[AppInfo().dayPicker].pickerTo, inComponent: 0, animated: true)
        toPicker?.reloadAllComponents()
    }
    
    func getIndex(_ day: String) {
        let array = AppInfo().daysPickerDay
        dayPickerSelected = (array?.firstIndex(of: day))!
    }
    
    func setupArray() {
        pickerDataFrom = pickerData
        pickerDataTo = pickerData
        
        pickerDataFrom.removeLast()
        pickerDataTo.removeFirst()
    }
    
    func getIntervals(start: String, end: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        var fromDate = formatter.date(from: start)
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.dateComponents([.hour, .minute], from: fromDate!)
        fromDate = calendar.date(bySettingHour: component.hour!, minute: 0, second: 0, of: fromDate!)!
        
        let thirtyMin: TimeInterval = 1800
        let endDate = formatter.date(from: end)!
        var intervals = Int(endDate.timeIntervalSince(fromDate!)/thirtyMin)
        intervals = intervals < 0 ? 0 : intervals
        
        for x in 0...intervals{
            let date = fromDate!.addingTimeInterval(TimeInterval(x)*thirtyMin)
            let df = DateFormatter()
            df.dateFormat = "HH:mm"
            pickerData.append(df.string(from: date))
        }
    }
    
    func checkDays() {
        switch AppInfo().dayPickerSelect {
        case Message.MONDAY.localized:
            AppInfo().dayPicker = 0
        case Message.TUESDAY.localized:
            AppInfo().dayPicker = 1
        case Message.WEDNESDAY.localized:
            AppInfo().dayPicker = 2
        case Message.THURSDAY.localized:
            AppInfo().dayPicker = 3
        case Message.FRIDAY.localized:
            AppInfo().dayPicker = 4
        case Message.SATURDAY.localized:
            AppInfo().dayPicker = 5
        case Message.SUNDAY.localized:
            AppInfo().dayPicker = 6
        default:
            break
        }
    }
    
    @IBAction func saveData(_ sender: Any) {
        self.close()
        UIView.animate(withDuration: 0.1, animations: {}, completion: { (finished : Bool) in
            if finished {
                print("finished",finished)
                self.handlerCloseView()
            }
        })
    }
    
    @objc func pickChanged(_ notification: Notification?) {
        checkDays()
        let index = AppInfo().dayPicker
        fromPicker?.selectRow(days[index].pickerFrom, inComponent: 0, animated: true)
        fromPicker?.reloadAllComponents()
        toPicker?.selectRow(days[index].pickerTo, inComponent: 0, animated: true)
        toPicker?.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == fromPicker {
            return pickerDataFrom.count
        }else {
            return pickerDataTo.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == fromPicker {
            return pickerDataFrom[row]
        }else {
            return pickerDataTo[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func getData(row: Int, pickerView: UIPickerView) {
        if pickerView == fromPicker {
            rowFrom = row
            checkDays()
            let day = AppInfo().dayPicker
            switch day {
            case 0...7:
                let schedule = pickerDataFrom[rowFrom] + " - " + pickerDataTo[rowTo]
                days[day].day = day
                days[day].time = schedule
                days[day].pickerFrom = rowFrom
                days[day].pickerTo = rowTo
            default:
                print("DefaultPicker")
            }
        }else if pickerView == toPicker {
            rowTo = row
            checkDays()
            let day = AppInfo().dayPicker
            switch day {
            case 0...7:
                let schedule = pickerDataFrom[rowFrom] + " - " + pickerDataTo[rowTo]
                days[day].day = day
                days[day].time = schedule
                days[day].pickerFrom = rowFrom
                days[day].pickerTo = rowTo
            default:
                print("DefaultPicker")
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromPicker {
            rowFrom = row
            if pickerDataFrom[rowFrom] == pickerDataTo[rowTo] {
                toPicker?.selectRow(rowTo + 1, inComponent: 0, animated: true)
                toPicker?.reloadAllComponents()
                rowTo = rowTo + 1
                getData(row: row, pickerView: pickerView)
            }else {
                if pickerDataFrom[rowFrom] > pickerDataTo[rowTo] {
                    rowTo = rowFrom + 1
                    toPicker?.selectRow(rowTo, inComponent: 0, animated: true)
                    toPicker?.reloadAllComponents()
                    getData(row: row, pickerView: pickerView)
                } else {
                    getData(row: row, pickerView: pickerView)
                }
            }
        }else {
            rowTo = row
            if pickerDataFrom[rowFrom] == pickerDataTo[rowTo] {
                fromPicker?.selectRow(rowFrom - 1, inComponent: 0, animated: true)
                fromPicker?.reloadAllComponents()
                rowFrom = rowFrom - 1
                getData(row: row, pickerView: pickerView)
            }else {
                if pickerDataFrom[rowFrom] > pickerDataTo[rowTo] {
                    rowFrom = rowTo - 1
                    fromPicker?.selectRow(rowFrom, inComponent: 0, animated: true)
                    fromPicker?.reloadAllComponents()
                    getData(row: row, pickerView: pickerView)
                }else {
                    getData(row: row, pickerView: pickerView)
                }
            }
        }
    }
    
}
