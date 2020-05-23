//
//  StoryboardExtension.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/2/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

//Aqui se enlistan los segues de toda la App
enum SeguesIdentifiers : String {
    
    case openInputEmailUserSegueID = "openInputEmailUserSegueID"
    case openCodeVerification = "openCodeVerification"
    case openRegisterName = "openRegisterName"
    case openRegisterDataHost = "openRegisterDataHost"
    case openLoginPassword = "openLoginPassword"
    case openRecoveryPassword = "openRecoveryPassword"
    case openDataNameHost = "openDataNameHost"
    case openMapHost = "openMapHost"
    case openStoreData = "openStoreData"
    case openMapPulley = "openMapPulley"
    case openSearchHome = "openSearchHome"
    case openShiftAddress = "openShiftAddress"
    case openShiftInformation = "openShiftInformation"
    case openShiftUser = "openShiftUser"
    case embbedChildStoreMapSegueID = "embbedChildStoreMapSegueID"
    case embbedChildStoreTableSegueID = "embbedChildStoreTableSegueID"
    case embbedChildShiftViewSegueID = "embbedChildShiftViewSegueID"
    case embbedChildShiftMapSegueID = "embbedChildShiftMapSegueID"
    case embbedChildMapShiftSegueID = "embbedChildMapShiftSegueID"
    case openAddressPopView2 = "openAddressPopView2"
    case openAddressPopView3 = "openAddressPopView3"
    case openShiftInformationUser = "openShiftInformationUser"
    case openStoreHost = "openStoreHost"
    case openRegisterHost = "openRegisterHost"
    case openProfileHost = "openProfileHost"
    
    
}

extension UIStoryboard {
    
    class func Tutorial() -> UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: nil)
    }
    
    class func CustomAlerts() -> UIStoryboard {
        return UIStoryboard(name: "CustomAlerts", bundle: nil)
    }
    
    class func Login() -> UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    class func Menu() -> UIStoryboard {
        return UIStoryboard(name: "Menu", bundle: nil)
    }
    
    class func MenuHost() -> UIStoryboard {
        return UIStoryboard(name: "MenuHost", bundle: nil)
    }
    
    class func Home() -> UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
    
    class func ResetPassword() -> UIStoryboard {
        return UIStoryboard(name: "ResetPassword", bundle: nil)
    }
    
    class func GetShiftAddress() -> UIStoryboard {
        return UIStoryboard(name: "GetShift", bundle: nil)
    }
    
    
    
    static func loadTutorial() {
        let iphoneStoryboard = UIStoryboard.Tutorial()
        let navViewController = iphoneStoryboard.instantiateInitialViewController()
        
        appDelegate().window?.rootViewController = navViewController
        appDelegate().window?.makeKeyAndVisible()
        
        UIView.transition(with: appDelegate().window!, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    static func loadLogin() {
        let iphoneStoryboard = UIStoryboard.Login()
        let navViewController = iphoneStoryboard.instantiateInitialViewController()
        
        appDelegate().window?.rootViewController = navViewController
        appDelegate().window?.makeKeyAndVisible()
        
        UIView.transition(with: appDelegate().window!, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    static func loadMenu() {
        let iPhoneStoryboard = UIStoryboard.Menu()
        let navViewController = iPhoneStoryboard.instantiateInitialViewController()
        
        appDelegate().window?.rootViewController = navViewController
        appDelegate().window?.makeKeyAndVisible()
    }
    
    static func loadMenuHost() {
        let iPhoneStoryboard = UIStoryboard.MenuHost()
        let navViewController = iPhoneStoryboard.instantiateInitialViewController()
        
        appDelegate().window?.rootViewController = navViewController
        appDelegate().window?.makeKeyAndVisible()
    }
    
    static func loadResetPassword() {
        let iPhoneStoryboard = UIStoryboard.ResetPassword()
        let navViewController = iPhoneStoryboard.instantiateInitialViewController()
        
        appDelegate().window?.rootViewController = navViewController
        appDelegate().window?.makeKeyAndVisible()
    }
    
    static func loadShiftAddress() {
        let iPhoneStoryboard = UIStoryboard.GetShiftAddress()
        let navViewController = iPhoneStoryboard.instantiateInitialViewController()
        
        appDelegate().window?.rootViewController = navViewController
        appDelegate().window?.makeKeyAndVisible()
    }
    
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    
    
}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
}



extension UIView {
        func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            
            animation.toValue = toValue
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            
            self.layer.add(animation, forKey: nil)
        }
}
