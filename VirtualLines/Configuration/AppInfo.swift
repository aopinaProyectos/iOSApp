//
//  AppInfo.swift
//  VirtualLines
//
//  Created by Angel Omar Piña Vargas on 04/03/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation

//Clase que guarda variables principales de la App

class AppInfo {
    private enum AppKeys: String {
        case addressStreet
        case addressLat
        case addressLon
        case addressAlert
        case arraySearchHome
        case category
        case daysOff
        case dayPicker
        case daysPickerDay
        case dayPickerSelect
        case dayRemovePicker
        case isTutorialShowed
        case phone
        case password
        case screenWidth
        case screenHeigth
        case token
        case tokenPassword
        case userName
        case userLat
        case userLong
        case userAddress
        case addressName
        case isUserHost
        case storeIdSelectedHost
        case reasonHostCancel
        case lineName
        case minPeople
        case maxPeople
        case TSTime
        case ToleranceTime
        case haveAddressUser
        case isLocationEnabled
        case addressViewIsShow
        case nameUser
        case arrayFavorites
        
    }
    
    //Singleton
    class var sharedInstance: AppInfo {
        struct Singleton {
            static let instance = AppInfo()
        }
        
        return Singleton.instance
    }
    
    let defaults: UserDefaults
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    init(appDefaults: UserDefaults) {
        self.defaults = appDefaults
    }
    
    var isUserHost: Bool {
        get {
            return self.defaults.bool(forKey: AppKeys.isUserHost.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.isUserHost.rawValue)
        }
    }
    
    var addressViewIsShow: Bool {
        get {
            return self.defaults.bool(forKey: AppKeys.addressViewIsShow.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.addressViewIsShow.rawValue)
        }
    }
    
    var isTutorialShowed: Bool {
        get {
            return self.defaults.bool(forKey: AppKeys.isTutorialShowed.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.isTutorialShowed.rawValue)
        }
    }
    
    var addressAlert: Bool {
        get {
            return self.defaults.bool(forKey: AppKeys.addressAlert.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.addressAlert.rawValue)
        }
    }
    
    var haveAddressUser: Bool {
        get {
            return self.defaults.bool(forKey: AppKeys.haveAddressUser.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.haveAddressUser.rawValue)
        }
    }
    
    var isLocationEnabled: Bool {
        get {
            return self.defaults.bool(forKey: AppKeys.isLocationEnabled.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.isLocationEnabled.rawValue)
        }
    }
    
    var screenWidth: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.screenWidth.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.screenWidth.rawValue)
        }
    }
    
    var screenHeigth: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.screenHeigth.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.screenHeigth.rawValue)
        }
    }
    
    var token: String {
        get {
            return self.defaults.string(forKey: AppKeys.token.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.token.rawValue)
        }
    }
    
    var nameUser: String {
        get {
            return self.defaults.string(forKey: AppKeys.nameUser.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.nameUser.rawValue)
        }
    }
    
    var tokenPassword: String {
        get {
            return self.defaults.string(forKey: AppKeys.tokenPassword.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.tokenPassword.rawValue)
        }
    }
    
    var phone: String {
        get {
            return self.defaults.string(forKey: AppKeys.phone.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.phone.rawValue)
        }
    }
    
    var password: String {
        get {
            return self.defaults.string(forKey: AppKeys.password.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.password.rawValue)
        }
    }
    
    var userName: String {
        get {
            return self.defaults.string(forKey: AppKeys.userName.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.userName.rawValue)
        }
    }
    
    var dayPicker: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.dayPicker.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.dayPicker.rawValue)
        }
    }
    
    var dayPickerSelect: String {
        get {
            return self.defaults.string(forKey: AppKeys.dayPickerSelect.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.dayPickerSelect.rawValue)
        }
    }
    
    var dayRemovePicker: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.dayRemovePicker.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.dayRemovePicker.rawValue)
        }
    }
    
    var category: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.category.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.category.rawValue)
        }
    }
    
    var arraySearchHome: [String]? {
        get {
            return self.defaults.stringArray(forKey: AppKeys.arraySearchHome.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.arraySearchHome.rawValue)
        }
    }
    
    var arrayFavorites: [String]? {
        get {
            return self.defaults.stringArray(forKey: AppKeys.arrayFavorites.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.arrayFavorites.rawValue)
        }
    }
    
    var daysOff: [String]? {
        get {
            return self.defaults.stringArray(forKey: AppKeys.daysOff.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.daysOff.rawValue)
        }
    }
    
    var daysPickerDay: [String]? {
        get {
            return self.defaults.stringArray(forKey: AppKeys.daysPickerDay.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.daysPickerDay.rawValue)
        }
    }
    
    var addressStreet: String {
        get {
            return self.defaults.string(forKey: AppKeys.addressStreet.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.addressStreet.rawValue)
        }
    }
    
    var addressLat: Double {
        get {
            return self.defaults.double(forKey: AppKeys.addressLat.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.addressLat.rawValue)
        }
    }
    
    var addressLon: Double {
        get {
            return self.defaults.double(forKey: AppKeys.addressLon.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.addressLon.rawValue)
        }
    }
    
    var userLat: Double {
        get {
            return self.defaults.double(forKey: AppKeys.userLat.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.userLat.rawValue)
        }
    }
    
    var userLong: Double {
        get {
            return self.defaults.double(forKey: AppKeys.userLong.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.userLong.rawValue)
        }
    }
    
    var userAddress: String {
        get {
            return self.defaults.string(forKey: AppKeys.userAddress.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.userAddress.rawValue)
        }
    }
    
    var addressName: String {
        get {
            return self.defaults.string(forKey: AppKeys.addressName.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.addressName.rawValue)
        }
    }
    
    var storeIdSelectedHost: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.storeIdSelectedHost.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.storeIdSelectedHost.rawValue)
        }
    }
    
    var reasonHostCancel: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.reasonHostCancel.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.reasonHostCancel.rawValue)
        }
    }
    
    var lineName: String {
        get {
            return self.defaults.string(forKey: AppKeys.lineName.rawValue)!
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.lineName.rawValue)
        }
    }
    
    var minPeople: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.minPeople.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.minPeople.rawValue)
        }
    }
    
    var maxPeople: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.maxPeople.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.maxPeople.rawValue)
        }
    }
    
    var TSTime: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.TSTime.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.TSTime.rawValue)
        }
    }
    
    var ToleranceTime: Int {
        get {
            return self.defaults.integer(forKey: AppKeys.ToleranceTime.rawValue)
        }
        
        set(newName) {
            self.defaults.set(newName, forKey: AppKeys.ToleranceTime.rawValue)
        }
    }
}

