//
//  AppConfig.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

//let kBaseURL = "http://3.14.149.104:8080/virtualLines"
//let kBaseURL = "http://18.222.195.150:8080/virtualLines"
//let kBaseURL = "http://18.223.117.118:8080/virtualLines"
//let kBaseURL = "http://34.66.53.101:8080/virtualLines"
//let kBaseURL = "http://18.217.49.248:8080/virtualLines"
//let kBaseURL = "http://3.87.195.145:8080/virtualLines"
//let kBaseURL = "http://13.59.102.235:8080/virtualLines"
let kBaseURL = "http://3.16.42.39:8080/virtualLines"

// Configuration to Paths
let kPGetToken = "/oauth/token"
let kPSendPhone = "/v1/r1/send/code/phone"
let kPCheckStatus = "/v1/r1/customer/status/phone"
let kPVerifCode = "/v1/r1/verification/code/phone"
let kPSignupUser = "/v1/r1/customer/signup"
let kPSignupHost = "/v1/r1/host/signup"
let kPLogin = "/v1/r1/customer/login"
let kPGetEmail = "/v1/r1/reset/password/get/email/phone"
let kPSendEmail = "/v1/r1/reset/password/send/email/phone"
let kPResetPassword = "/v1/r1/reset/password/phone"
let kPCategories = "/v1/r1/store/categories"
let kPFrequentPlaces = "/v1/r1/store/places/category"
let kPGetNearPlaces = "/v1/r1/store/places/category"
let KPGetPlaces = "/v1/r1/store/places/category"
let kPGetUserProfile = "/v1/r1/customer/profile/phone"
let kPGetInfoLines = "/v1/r1/store"
let kPGetShiftUser = "/v1/r1/shift/new"
let kPGetAllShiftActive = "/v1/r1/shift/phone"
let kPCompleteShift = "/v1/r1/shift"
let kPCancelShift = "/v1/r1/shift"
let kPSearchStoreID = "/v1/r1/store"
let kPFavoritesStores = "/v1/r1/store/places/category/0/favorites/phone"
let kPChangePassword = "/v1/r1/customer/change/password/phone"
let kPUpdateProfile = "/v1/r1/customer/profile/phone"
let kSetFavoritePlace = "/v1/r1/store/places/favorites/phone"
let kSetTutorial = "/v1/r1/app/intro"
let kPUploadImage = "/v1/r1/store"
let kPFindPlacesAny = "/v1/r1/store/places/criteria"
let kPGetRoutes = "/v1/r1/store/places/directions/phone"
let kPGetTimeArrival = "/v1/r1/store/places/distances"
let kPUpdateShift = "/v1/r1/shift"
let kPGetAllStoreHost = "/v1/r1/store/places/by/owner/phone"
let kPGetAllLinesHost = "/v1/r1/store"
let kPGetNextShift = "/v1/r1/shift/store/by/virtual/line"
let kPCompleteByHost = "/v1/r1/shift"
let kPUpdateShiInPlace = "/v1/r1/shift"
let kPCancelShiftByHost = "/v1/r1/shift"
let kPCreateLine = "/v1/r1/store"
let kPGetStatus = "/v1/r1/shift"
let kPGetAddressUser = "/v1/r1/customer/locations/phone"
let kPSaveAddressUser = "/v1/r1/customer/location"
let kPUpdateAddressUser = "/v1/r1/customer/location"

// TimeOut to manage the connection depending the internet Connection.
let kTimeOutNormal = 60
let kTimeOutSlow = 180


// Configuration to identifier
let kIdentifierApp = "iOS_APP"

// Configuration to OAUTH 2.0 Basic  Credentials
let kOAuthUserName = "devglan-client"
let kOAuthPassword = "devglan-secret"

//GoogleMaps
//let googleMapsApiKey = "AIzaSyAWo8A1sM9Ch33twK-ywIS2r8E7AhXGUH4"
let googleMapsApiKey = "AIzaSyCd3gMJz5ZCFQgWJEWLrXrk4A93M1y5tOo"
let googleMapsPlacesApiKey = "AIzaSyCd3gMJz5ZCFQgWJEWLrXrk4A93M1y5tOo"
let baseURLGMP = "https://maps.googleapis.com/maps/api/geocode/json?"

//Colors
//Tutorial
let kColorTuBackground = #colorLiteral(red: 0, green: 0.3995446265, blue: 0.3875438571, alpha: 1)

//PageControl
let kColorPaSelect = #colorLiteral(red: 0.1954364777, green: 0.7037317753, blue: 0.7031692863, alpha: 1)
//General
let kColorActive = #colorLiteral(red: 0.3621281683, green: 0.3621373773, blue: 0.3621324301, alpha: 1)
let kColorInactive = #colorLiteral(red: 0.7644005418, green: 0.7579394579, blue: 0.7676199079, alpha: 1)
let kColorButtonActive = #colorLiteral(red: 0.1954364777, green: 0.7037317753, blue: 0.7031692863, alpha: 1)
let kColorButtonInactive = #colorLiteral(red: 0.8765067458, green: 0.876527369, blue: 0.8765162826, alpha: 1)
let kColorError = #colorLiteral(red: 0.8950581551, green: 0, blue: 0, alpha: 1)
let kColorTabBar = #colorLiteral(red: 0.1954713762, green: 0.4916740656, blue: 0.6825134158, alpha: 1)
let kColorBorderCell = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
let kColorPlaceHolder = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
let kColorText = #colorLiteral(red: 0.3621281683, green: 0.3621373773, blue: 0.3621324301, alpha: 1)
let kColorSearchBar = #colorLiteral(red: 0.1954713762, green: 0.4916740656, blue: 0.6825134158, alpha: 1)
let kColorTextSB = UIColor.white

//Font
//------------
//Tutorial
//IphoneSE
let kSFontIpSETuLabel = CGFloat(12)
let ksFontIpSETuTitle = CGFloat(19)

//DaysSchedule
let MonFri = 4
let MonSun = 6

//TimeScheduleAlert
let kTimeStart = "08:00"
let kTimeEnd = "22:00"

//Images
let kImageBanks = UIImage(named: "Banks")
let kImageRestaurant = UIImage(named: "Restaurants")
let kImageEnterteinment = UIImage(named: "Enterteinment")
let kImageHealth = UIImage(named: "Health")
let kImageEducation = UIImage(named: "Education")
let kImagePets = UIImage(named: "Pets")

//StatusShiftHost
let KStatusVigente = 1
let kStatusEnSitio = 2
let kStatusEnServicio = 3

let kArraysImages = [kImageBanks, kImageRestaurant, kImageEnterteinment, kImageHealth, kImageEducation, kImagePets]


class AppConfig {
    struct AppSetup{
        struct BaseURL {
            enum Environment : String {
                case Develop = ""
                case Production = "http://18.223.117.118:8080/virtualLines/"
            }
        }
    }

    static func URLBaseScheme() -> String {
        #if DEVELOP
            return AppSetup.BaseURL.Environment.Develop.rawValue
        #else
            return AppSetup.BaseURL.Environment.Production.rawValue
        #endif
    }
}
