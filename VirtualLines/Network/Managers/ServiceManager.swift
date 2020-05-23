//
//  ServiceManager.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/11/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class ServiceManager: DataManagerDelegate {
    
    
    let disposeBag: DisposeBag = DisposeBag()
    
    func getToken() {
        APIVirtualLines.getToken().debug("APIVirtualLines.GetToken").subscribe(onNext: {(token) in
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
    
    func sendCode(phone: String) {
        APIVirtualLines.checkLogin(number: phone).debug("APIVirtualLines.SendCode").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            print (dataResponse)
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func verificationCode(phone: String, code: String) {
        APIVirtualLines.verificationCode(code: code, number: phone).debug("APIVirtualLines.SendCode").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            print (dataResponse)
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func responseDataManager<T>(_ response: T) {
        print(response)
    }
    
}
