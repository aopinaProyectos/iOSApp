//
//  ViewcontrollerExtension.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/17/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController {
    
    
    func stringToCrypto(text: String) -> String {
         return Crypto().encrypt(value: text)
    }
    
    func CryptoToString(text: String) -> String {
        return Crypto().decrypt(value: text)
    }
    
    func jsonToString(jsonTOConvert: Data)-> String {
        var result = ""
        do {
            let convertedString = String(data: jsonTOConvert, encoding: String.Encoding.utf8)
            result = convertedString!
        } catch let myJSONError {
            print(myJSONError)
            return ""
        }
        return result
    }
    
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: .init(rawValue: 0))
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    func hideKeyBoardWhenTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setOpaqueNavigationBar()  {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.view.backgroundColor = kColorTabBar
        self.navigationController?.navigationBar.backgroundColor = kColorTabBar
        self.navigationController?.navigationBar.barTintColor = kColorTabBar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white// Aqui se tiene que cambiar aopina
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage!;
    }
    
    func setTitle(_ title: String) {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        let titleView = UIStackView(arrangedSubviews: [titleLbl])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        self.parent!.navigationItem.titleView = titleView
    }
    
    func setTitleChild(_ title: String) {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        let titleView = UIStackView(arrangedSubviews: [titleLbl])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        self.navigationItem.titleView = titleView
    }
    
    func imageTo64(_ image: UIImage) -> String {
        let imageData = image.pngData()?.base64EncodedString()
        return imageData!
    }
    
    func dataToImage(base: String) -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: base, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        return decodedimage!
    }
    
    func getTokenRenew() {
        let disposeBag: DisposeBag = DisposeBag()
        APIVirtualLines.getToken().debug("APIVirtualLines.GetToken").subscribe(onNext: {(token) in
            print("📡 Hay conexión a Internet 📡")
            print ("onNext")
            print (token)
            AppInfo().token = token.access_token
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func applyLocalizationStatus(status: String) -> String {
        switch status{
        case "CLIENTE EN EL NEGOCIO":
            return Message.INPLACE.localized
        default:
            return ""
        }
    }
    
}

extension UITableViewCell {
    func applyLocalizationStatus(status: String) -> String {
        switch status{
        case "CLIENTE EN EL NEGOCIO":
            return Message.INPLACE.localized
        default:
            return ""
        }
    }
}

extension Notification.Name {
    static let pickChanged = NSNotification.Name("pickChanged")
}

extension UIView: Bluring {}

protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.3) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}



