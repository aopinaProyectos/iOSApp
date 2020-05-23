//
//  APIVirtualLines.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire
import ObjectMapper
import RxSwift
import SystemConfiguration

class APIVirtualLines {
    
    
    
    //Set Headers
    static func setHeaders() -> HTTPHeaders {
        var headers : HTTPHeaders? = nil
        headers = ["userType": kIdentifierApp,
                   "userId" : ReachabilityManager.getWiFiAddress(),
                   "language" : "es",
                   "Content-Type" : "application/json;charset=UTF-8"] as? HTTPHeaders
        return headers!
    }
    
    static func setTimeOutNormal() -> SessionManager {
        var alamoFireManager = Alamofire.SessionManager.default
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        let policies: [String: ServerTrustPolicy] = [
            "http://18.223.117.118:8080/": .disableEvaluation
        ]
        let trustPolicies = ServerTrustPolicyManager(policies: policies)
        alamoFireManager = Alamofire.SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: trustPolicies)
        return alamoFireManager
    }
    
    static func tokenRenew(completion: @escaping (Bool) -> Void) {
        var flag =  false
        var headers : HTTPHeaders? = nil
        var body: Parameters
        let ip = ReachabilityManager.getWiFiAddress()
        let url = kBaseURL + kPGetToken
        headers = ["userType": kIdentifierApp,
                   "userId" : ip,
                   "Content-Type" : "application/x-www-form-urlencoded"] as? HTTPHeaders
        body = [
            "username" : "batman",
            "password" : "acc3s#19$;",
            "grant_type" : "password"
        ]
        Alamofire.request(url, method: .post, parameters: body, encoding: URLEncoding(), headers: headers).authenticate(user: "devglan-client", password: "devglan-secret").responseString { response in
            
            switch response.result {
                
            case .success:
                print ("-----> \(response)")
                //Selector de errores y de success
                if let status = response.response?.statusCode {
                    print ("-----> Status HTTP:  \(String(describing: status))")
                    switch status {
                    case 200...210:
                        let data = response.result.value
                        if data!.isEmpty {
                            flag = false
                        }else {
                            let token = Mapper<Token>().map(JSONString: data!)
                            AppInfo().token = token!.access_token
                            flag = true
                        }
                    default:
                        break
                    }
                }else {
                    print("Error")
                    flag = false
                }
                
            case .failure(let error):
                flag = false
                print ("-----> \(error.localizedDescription)")
                if error._code == -1001 {
                    print("TimeOut")
                }else if error._code == -1009 {
                    print("Internet")
                }else {
                    print("Error")
                }
            }
            completion(flag)
        }
    }
    
    static func getTokenRenew() -> Bool {
        var flag = true
        var headers : HTTPHeaders? = nil
        var body: Parameters
        let ip = ReachabilityManager.getWiFiAddress()
        let url = kBaseURL + kPGetToken
        headers = ["userType": kIdentifierApp,
                   "userId" : ip,
                   "Content-Type" : "application/x-www-form-urlencoded"] as? HTTPHeaders
        body = [
            "username" : "batman",
            "password" : "acc3s#19$;",
            "grant_type" : "password"
        ]
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 60
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = 60
        
        Alamofire.request(url, method: .post, parameters: body, encoding: URLEncoding(), headers: headers).authenticate(user: "devglan-client", password: "devglan-secret").responseString { response in
            
            switch response.result {
                
            case .success:
                print ("-----> \(response)")
                //Selector de errores y de success
                if let status = response.response?.statusCode {
                    print ("-----> Status HTTP:  \(String(describing: status))")
                    switch status {
                    case 200...210:
                        let data = response.result.value
                        if data!.isEmpty {
                            flag = false
                        }else {
                            let token = Mapper<Token>().map(JSONString: data!)
                            AppInfo().token = token!.access_token
                            flag = true
                        }
                    default:
                        break
                    }
                }else {
                    flag = false
                }
                
            case .failure(let error):
                print ("-----> \(error.localizedDescription)")
                flag = false
            }
        }
        return flag
    }
    
    //Method that get the Token that is used for all the EndPoints
    static func getToken() -> Observable<Token> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            var body: Parameters
            let ip = ReachabilityManager.getWiFiAddress()
            let url = kBaseURL + kPGetToken
            headers = ["userType": kIdentifierApp,
                       "userId" : ip,
                       "Content-Type" : "application/x-www-form-urlencoded"] as? HTTPHeaders
            body = [
                "username" : "batman",
                "password" : "acc3s#19$;",
                "grant_type" : "password"
            ]
            
            Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 60
            Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = 60
            
            Alamofire.request(url, method: .post, parameters: body, encoding: URLEncoding(), headers: headers).authenticate(user: "devglan-client", password: "devglan-secret").responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 200...210:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let token = Mapper<Token>().map(JSONString: data!)
                                observable.onNext(token!)
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetToken")
            }
        }
        
    }
    
    // Method that check the status of a User
    static func checkStatus(number: String) ->Observable<Response>{
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            var body: Parameters
            let url = kBaseURL + kPCheckStatus + "/" +  number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    let data = response.result.value
                    //let data = response.result.value
                    if data!.isEmpty {
                        observable.onError(NetworkingError.NoData)
                    }else {
                        let dataResponse = Mapper<Response>().map(JSONString: data!)
                        observable.onNext(dataResponse!)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: Check Status User")
            }
        }
    }
    
    static func login(body: [String:Any]) -> Observable<Login> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPLogin + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Login>().map(JSONString: data!)
                                if dataResponse?.response?.code == 210 {
                                    observable.onNext(dataResponse!)
                                }else if dataResponse?.response?.code == 219 {
                                    observable.onError(CatalogError.ErrorPassword(message: dataResponse!.response!))
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: Login")
            }
        }
    }
    
    static func signUpHost(body: StoreProfile, number: String) -> Observable<SignUpHost> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPSignupHost + "/phone/" +  number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 200...210:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<SignUpHost>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: Login")
            }
        }
    }
    
    // Method that send the code Verification, also let us to know if a User is Registered
    static func checkLogin(number: String) ->Observable<Response>{
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            var body: Parameters
            let ip = ReachabilityManager.getWiFiAddress()
            let url = kBaseURL + kPSendPhone + "/" +  number + "?access_token=" + AppInfo().token
            headers = ["userType": kIdentifierApp,
                       "userId" : ip,
                       "language" : "es",
                       "Content-Type" : "application/json;charset=UTF-8"] as? HTTPHeaders
            //body = ["access_token" : AppInfo().token]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    let data = response.result.value
                    //let data = response.result.value
                    if data!.isEmpty {
                        observable.onError(NetworkingError.NoData)
                    }else {
                        let dataResponse = Mapper<Response>().map(JSONString: data!)
                        observable.onNext(dataResponse!)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SendCodeVerification")
            }
        }
    }
    
    static func verificationCode(code: String, number: String) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            var body: Parameters
            let ip = ReachabilityManager.getWiFiAddress()
            let url = kBaseURL + kPVerifCode + "/" +  number + "/code/" + code + "?access_token=" + AppInfo().token
            headers = ["userType": kIdentifierApp,
                       "userId" : ip,
                       "language" : "es",
                       "Content-Type" : "application/json;charset=UTF-8"] as? HTTPHeaders
            //body = ["access_token" : AppInfo().token]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 200:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 210 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SendCodeVerification")
            }
        }
    }
    
    static func signupUser(body: [String:Any]) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let ip = ReachabilityManager.getWiFiAddress()
            let url = kBaseURL + kPSignupUser + "?access_token=" + AppInfo().token
            headers = ["userType": kIdentifierApp,
                       "userId" : ip,
                       "language" : "es",
                       "Content-Type" : "application/json;charset=UTF-8"] as? HTTPHeaders
            
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    let data = response.result.value
                    //let data = response.result.value
                    if data!.isEmpty {
                        observable.onError(NetworkingError.NoData)
                    }else {
                        let dataResponse = Mapper<Response>().map(JSONString: data!)
                        observable.onNext(dataResponse!)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SendCodeVerification")
            }
        }
    }
    
    static func sendCodeAgain(number: String) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let ip = ReachabilityManager.getWiFiAddress()
            let url = kBaseURL + kPSendPhone + "/" +  number + "?access_token=" + AppInfo().token
            headers = ["userType": kIdentifierApp,
                       "userId" : ip,
                       "language" : "es",
                       "Content-Type" : "application/json;charset=UTF-8"] as? HTTPHeaders
            //body = ["access_token" : AppInfo().token]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SendCodeVerification")
            }
        }
    }
    
    static func getCategories() -> Observable<Categories> {
        return Observable.create { observable in
            //AppInfo().token = "ec88a639-16fd-4784-a671-3132aae3293d"
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPCategories + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Categories>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                                observable.onCompleted()
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    //observable.onCompleted()
    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetCategories")
            }
        }
    }
    
    static func getEmailRecover(number: String) -> Observable<EmailRecover> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetEmail + "/" +  number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            //body = ["access_token" : AppInfo().token]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    let data = response.result.value
                    //let data = response.result.value
                    if data!.isEmpty {
                        observable.onError(NetworkingError.NoData)
                    }else {
                        let dataResponse = Mapper<EmailRecover>().map(JSONString: data!)
                        observable.onNext(dataResponse!)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SendCodeVerification")
            }
        }
    }
    
    static func sendEmail(body: [String:Any], number: String) -> Observable<EmailSend> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPSendEmail + "/" + number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    let data = response.result.value
                    //let data = response.result.value
                    if data!.isEmpty {
                        observable.onError(NetworkingError.NoData)
                    }else {
                        let dataResponse = Mapper<EmailSend>().map(JSONString: data!)
                        if dataResponse?.response?.code == 414 {
                            observable.onNext(dataResponse!)
                        }
                        
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SendEmailRecover")
            }
        }
    }
    
    static func resetPassword(body: [String:Any], number: String) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPResetPassword + "/" + number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    let data = response.result.value
                    //let data = response.result.value
                    if data!.isEmpty {
                        observable.onError(NetworkingError.NoData)
                    }else {
                        let dataResponse = Mapper<Response>().map(JSONString: data!)
                        observable.onNext(dataResponse!)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: ResetPassword")
            }
        }
    }
    
    static func getFrequentPlaces(category: Int) -> Observable<Places> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let number = AppInfo().phone
            let url = kBaseURL + kPFrequentPlaces + "/" + String(category) + "/frequency/phone/" + number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                if dataResponse?.response?.code == 911 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                if dataResponse?.response?.code == 917 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetFrequentPlaces")
            }
        }
    }
    
    static func getNearPlaces(body: [String:Any], category: Int) -> Observable<Places> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetNearPlaces + "/" + String(category) + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }else if dataResponse?.response?.code == 814 {
                                    observable.onError(CatalogError.NotFoundPlaces) //Esto se tiene que cambiar aopina
                                    observable.onCompleted()
                                }else {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                        break
                        }
                    }
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetNearPlaces")
            }
        }
    }
    
    static func getPlacesByName(body: [String:Any], category: Int, store: String) -> Observable<Places> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + KPGetPlaces + "/" + String(category) + "/" + "Store/" + store +  "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                    
                case .success:
                    print ("-----> \(response)")
                    let data = response.result.value
                    //let data = response.result.value
                    if data!.isEmpty {
                        observable.onError(NetworkingError.NoData)
                    }else {
                        let dataResponse = Mapper<Places>().map(JSONString: data!)
                        if dataResponse?.response?.code == 811 {
                            observable.onError(CatalogError.NotFoundPlaces)
                        }else if dataResponse?.response?.code == 814 {
                            observable.onError(CatalogError.NotFoundPlaces) //Esto se tiene que cambiar aopina
                        }else {
                            observable.onNext(dataResponse!)
                        }
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetNearPlaces")
            }
        }
    }
    
    static func getUserProfile(number: String) -> Observable<Profile> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetUserProfile + "/" + number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 500:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Profile>().map(JSONString: data!)
                                observable.onError(CatalogError.ErrorGeneral(message: dataResponse!.response!))
                                observable.onCompleted()
                            }
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 200...210:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Profile>().map(JSONString: data!)
                                switch dataResponse?.response?.code {
                                case 610:
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                default:
                                    observable.onError(CatalogError.ErrorPassword(message: dataResponse!.response!))
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    //observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                        observable.onCompleted()
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                        observable.onCompleted()
                    }else {
                        observable.onError(error)
                        observable.onCompleted()
                    }
                    //observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetUserProfile")
            }
        }
    }
    
//    Service to get the information of Shift
    static func getInfoShift(storeId: Int) -> Observable<DetailShift> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetInfoLines + "/" + String(storeId) + "/virtual/lines/preview" + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DetailShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1124 {
                                    observable.onError(CatalogError.NoLinesFound(message: dataResponse!.response!))
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DetailShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1423 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: Login")
            }
        }
    }
    
    
    //    Service to get the Shift
    static func getUserShift(body: ShiftNewTurn) -> Observable<ShiftUser> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetShiftUser + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DetailShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1111 {
                                    observable.onError(CatalogError.NoLinesFound(message: dataResponse!.response!))
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<ShiftUser>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1110 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                        observable.onCompleted()
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                        observable.onCompleted()
                    }else {
                        observable.onError(error)
                        observable.onCompleted()
                    }
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetShiftUser")
            }
        }
    }
    
    
    //    Service to get All the Shifts
    static func getAllShifts(phone: String) -> Observable<ActiveShift> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetAllShiftActive + "/" + phone + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DetailShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1124 {
                                    observable.onError(CatalogError.NoLinesFound(message: dataResponse!.response!))
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<ActiveShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1123 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    //observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetShiftUser")
            }
        }
    }
    
    
    //    Service to get All the Shifts
    static func completeShift(shift: Int, line: Int) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let shi = String(shift)
            let lin = String(line)
            let url = kBaseURL + kPCompleteShift + "/" + shi + "/virtual/line/" + lin + "/completed/user?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetShiftUser")
            }
        }
    }
    
    //    Service to get All the Shifts
    static func cancelShift(shift: Int, line: Int, reason: Int) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let shi = String(shift)
            let lin = String(line)
            let url = kBaseURL + kPCancelShift + "/" + shi + "/virtual/line/" + lin + "/canceled/user/reason/" + String(reason) + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CancelShiftByHost")
            }
        }
    }
    
    
    //    Service to get Store Information by ID
    static func getStoreInformation(id: Int) -> Observable<InfoStore> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let idString = String(id)
            let url = kBaseURL + kPSearchStoreID + "/" + idString +  "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<InfoStore>().map(JSONString: data!)
                                
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<InfoStore>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetShiftUser")
            }
        }
    }
    
    
    //    Service to get Favorites Places
    static func getFavoritesPlaces(number: String) -> Observable<Places> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPFavoritesStores + "/" + number +  "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                switch dataResponse?.response?.code {
                                case 911:
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                default:
                                    observable.onError(CatalogError.ErrorGeneral(message: dataResponse!.response!))
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                                observable.onCompleted()
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    //observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                        observable.onCompleted()
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                        observable.onCompleted()
                    }else {
                        observable.onError(error)
                        observable.onCompleted()
                    }
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetShiftUser")
            }
        }
    }
    
    
    //    Service to change Password From Profile
    static func changePassword(number: String, body: Password) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPChangePassword + "/" + number +  "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            } else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                switch dataResponse?.code {
                                case 610:
                                    observable.onNext(dataResponse!)
                                case 614:
                                    observable.onError(CatalogError.ErrorGeneral(message:dataResponse!))
                                default:
                                    break
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: ChangePassword")
            }
        }
    }
    
    //    Service to change Password From Profile
    static func updateProfile(number: String, body: UpdateProfile, image: UIImage) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            var bodyCollection = [String : Any]()
            let url = kBaseURL + kPUpdateProfile + "/" + number +  "?access_token=" + AppInfo().token
            headers = ["userType": kIdentifierApp,
                       "userId" : ReachabilityManager.getWiFiAddress(),
                       "language" : "es",
                       "Content-Type" : "application/json;charset=UTF-8"] as? HTTPHeaders
            let fileData = image.jpegData(compressionQuality: 0.7)
            let json = body.toJSONString()
            bodyCollection["user"] = body.toJSON()
            //bodyCollection["file"] = fileData
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(fileData!, withName: "file", fileName: "Image.jpg", mimeType: "image/jpg")
                multipartFormData.append((json?.data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "user")
            }, to: url, method: .put, encodingCompletion: { (result) in
            //Alamofire.request(url, method: .put, parameters: bodyCollection, headers: headers).responseString { response in
                switch result {
                case .success(let upload, _, _):
                    print ("-----> \(result)")
                    upload.responseJSON { response in
                        if let status = response.response?.statusCode {
                            print ("-----> Status HTTP:  \(String(describing: status))")
                            switch status {
                            case 401:
                                tokenRenew() {
                                    (flag) in
                                    if flag {
                                        observable.onError(CatalogError.TokenRenew)
                                        observable.onCompleted()
                                    }else {
                                        observable.onError(CatalogError.Unknown)
                                        observable.onCompleted()
                                    }
                                }
                            case 200...400:
                                let data = response.result.value
                                let dataResponse = Mapper<Response>().map(JSONObject: data!)
                                switch dataResponse!.code {
                                case 119:
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                default:
                                    observable.onError(CatalogError.ErrorGeneral(message: dataResponse!))
                                    observable.onCompleted()
                                }
                            default:
                                break
                            }
                        }
                    }
                    
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    
    //    Service to change Password From Profile
    static func setFavorite(number: String, body: Favorites) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kSetFavoritePlace + "/" + number +  "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            } else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                switch dataResponse?.code {
                                case 913:
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                case 914:
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                case 610:
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                case 614:
                                    observable.onError(CatalogError.ErrorGeneral(message:dataResponse!))
                                    observable.onCompleted()
                                default:
                                    break
                                }
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                        observable.onCompleted()
                    }
                    //observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SetFavoritePlaces")
            }
        }
    }
    
    //    Service get info Tutorial
    static func getInfoTutorial() -> Observable<Intro> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kSetTutorial  +  "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    //Selector de errores y de success
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                }
                            }
                        case 404...410:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            }else {
                                let dataResponse = Mapper<Intro>().map(JSONString: data!)
                                
                            }
                        case 200...400:
                            let data = response.result.value
                            //let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                            } else {
                                let dataResponse = Mapper<Intro>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                            }
                        default:
                            break
                        }
                    }else {
                        observable.onError(NetworkingError.Unknown)
                    }
                    observable.onCompleted()
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                debugPrint("Disposed: SetFavoritePlaces")
            }
        }
    }
    
    
    //    Service to change Password From Profile
    static func uploadImageStore(storeId: Int, image: UIImage) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPUploadImage + "/" + String(storeId) + "/upload/image" + "?access_token=" + AppInfo().token
            headers = ["userType": kIdentifierApp,
                       "userId" : ReachabilityManager.getWiFiAddress(),
                       "language" : "es",
                       "Content-Type" : "application/json;charset=UTF-8"] as? HTTPHeaders
            let fileData = image.jpegData(compressionQuality: 0.7)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(fileData!, withName: "image", fileName: "Image.jpg", mimeType: "image/jpg")
            }, to: url, method: .post, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    print ("-----> \(result)")
                    upload.responseJSON { response in
                        if let status = response.response?.statusCode {
                            print ("-----> Status HTTP:  \(String(describing: status))")
                            switch status {
                            case 401:
                                tokenRenew() {
                                    (flag) in
                                    if flag {
                                        observable.onError(CatalogError.TokenRenew)
                                        observable.onCompleted()
                                    }else {
                                        observable.onError(CatalogError.Unknown)
                                        observable.onCompleted()
                                    }
                                }
                            case 200...400:
                                let data = response.result.value
                                let dataResponse = Mapper<Response>().map(JSONObject: data!)
                                switch dataResponse!.code {
                                case 100:
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                default:
                                    observable.onError(CatalogError.ErrorGeneral(message: dataResponse!))
                                    observable.onCompleted()
                                }
                            default:
                                break
                            }
                        }
                    }
                    
                    
                case .failure(let error):
                    print ("-----> \(error.localizedDescription)")
                    if error._code == -1001 {
                        observable.onError(NetworkingError.Timeout)
                    }else if error._code == -1009 {
                        observable.onError(NetworkingError.NoInternet)
                    }else {
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
    
    static func findPlacesByAny(body: [String:Any], text: String) -> Observable<Places> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPFindPlacesAny + "/" + text + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Places>().map(JSONString: data!)
                                if dataResponse?.response?.code == 810 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: FindPlacesByAny")
            }
        }
    }
    
    static func getRoutes(body: Routes, number: String) -> Observable<Directions> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetRoutes + "/" + number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Directions>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Directions>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Directions>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: FindPlacesByAny")
            }
        }
    }
    
    static func getTimeArrival(body: TimeArrival) -> Observable<DirectionsTime> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetTimeArrival + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: body.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DirectionsTime>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DirectionsTime>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DirectionsTime>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1010 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: FindPlacesByAny")
            }
        }
    }
    
    static func updateShift(shiftId: Int) -> Observable<UpdateShift> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPUpdateShift + "/" + String(shiftId) + "/virtual/line/status" + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<UpdateShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<UpdateShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<UpdateShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1432 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: FindPlacesByAny")
            }
        }
    }
    
    static func getAllStoreHost(number: String) -> Observable<StoreHost> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetAllStoreHost + "/" + number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<StoreHost>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<UpdateShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<StoreHost>().map(JSONString: data!)
                                if dataResponse?.response?.code == 146 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: FindPlacesByAny")
            }
        }
    }
    
    static func getAllLines(storeId: Int) -> Observable<virtualLine> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetAllLinesHost + "/" + String(storeId) + "/virtual/lines" + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<virtualLine>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<DetailShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<virtualLine>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1431 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: FindPlacesByAny")
            }
        }
    }
    
    
    
    static func getAllShift(criteria: CriteriaShifts) -> Observable<ManageShift> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetNextShift + "/" + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: criteria.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<ManageShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404...409:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<ManageShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1124 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<ManageShift>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1123 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: GetAllShift")
            }
        }
    }
    
    static func completeShiftByHost(line: Int, shift: String) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPCompleteByHost + "/" + shift + "/virtual/line/" + "\(line)" + "/completed/host" + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                                observable.onCompleted()
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CompleteShiftByHost")
            }
        }
    }
    
    static func updateShiftInPlace(line: Int, shift: String) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPUpdateShiInPlace + "/" + shift + "/virtual/line/" + "\(line)" + "/user/in/place" + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                                observable.onCompleted()
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CompleteShiftByHost")
            }
        }
    }
    
    
    static func cancelShiftByHost(line: Int, shift: Int, reason: Int) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPCancelShiftByHost + "/" + "\(shift)" + "/virtual/line/" + "\(line)" + "/canceled/host/reason/" + "\(reason)" + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                                observable.onCompleted()
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CompleteShiftByHost")
            }
        }
    }
    
    
    static func createLine(store: Int, line: LineCreated) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPCreateLine + "/" + "\(store)" + "/virtual/line/"  + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: line.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                                observable.onCompleted()
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CompleteShiftByHost")
            }
        }
    }
    
    
    static func updateLine(store: Int, line: LineCreated) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPCreateLine + "/" + "\(store)" + "/virtual/line/"  + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .put, parameters: line.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                observable.onNext(dataResponse!)
                                observable.onCompleted()
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CompleteShiftByHost")
            }
        }
    }
    
    
    static func getUserAddress(number: String) -> Observable<UserAddress> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPGetAddressUser + "/" + number + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<UserAddress>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1521 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<UserAddress>().map(JSONString: data!)
                                if dataResponse?.response?.code == 1520 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: FindPlacesByAny")
            }
        }
    }
    
    
    static func saveAddress(location: LocationSave) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPSaveAddressUser + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .post, parameters: location.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1516 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CompleteShiftByHost")
            }
        }
    }
    
    
    static func updateAddress(location: LocationSave) -> Observable<Response> {
        return Observable.create { observable in
            var headers : HTTPHeaders? = nil
            let url = kBaseURL + kPUpdateAddressUser + "?access_token=" + AppInfo().token
            headers = setHeaders()
            
            Alamofire.request(url, method: .put, parameters: location.toJSON(), encoding: JSONEncoding.default, headers: headers).responseString { response in
                
                switch response.result {
                case .success:
                    print ("-----> \(response)")
                    if let status = response.response?.statusCode {
                        print ("-----> Status HTTP:  \(String(describing: status))")
                        switch status {
                        case 401:
                            tokenRenew() {
                                (flag) in
                                if flag {
                                    observable.onError(CatalogError.TokenRenew)
                                    observable.onCompleted()
                                }else {
                                    observable.onError(CatalogError.Unknown)
                                    observable.onCompleted()
                                }
                            }
                        case 500:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1020 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        case 404:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 811 {
                                    observable.onError(CatalogError.NotFoundPlaces)
                                    observable.onCompleted()
                                }
                            }
                        case 200...400:
                            let data = response.result.value
                            if data!.isEmpty {
                                observable.onError(NetworkingError.NoData)
                                observable.onCompleted()
                            }else {
                                let dataResponse = Mapper<Response>().map(JSONString: data!)
                                if dataResponse?.code == 1518 {
                                    observable.onNext(dataResponse!)
                                    observable.onCompleted()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                case .failure(let error):
                    print ("-----> \(error)")
                    observable.onError(error)
                    observable.onCompleted()
                    
                }
            }
            return Disposables.create {
                debugPrint("Disposed: CompleteShiftByHost")
            }
        }
    }
    
    
    
}
