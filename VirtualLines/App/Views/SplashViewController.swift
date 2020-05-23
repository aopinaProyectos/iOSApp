//
//  ViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/1/19.
//  Copyright © 2019 APPS Realities. All rights reserved.
//

import UIKit
import Lottie
import RxSwift


class SplashViewController: UIViewController {
    
    @IBOutlet weak var virtualAnimationView: UIView!
    @IBOutlet weak var titleAnimation: UILabel!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    //Config Lottie
    let lottieLogo = LOTAnimationView(name: "Splash")
    var userLocations: [Locations] = [Locations]()
    var handlerSplash: () -> () = {}
    var isFinishedFlow : Bool = false
    var flag = 0
    var heightRunTime: CGFloat = 0
    var widthRunTime: CGFloat = 0
    var number = ""
    
    let services = ServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppInfo().addressViewIsShow = false
        //isInternetConnection()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        titleAnimation.text = "NextLine"
        //loadSplash()
        //self.getToken()
    }
    
    override func viewDidLayoutSubviews() {
        widthRunTime = self.virtualAnimationView.frame.size.width
        heightRunTime = self.virtualAnimationView.frame.size.height
        loadSplash()
        self.getToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSplash() {
        let width = virtualAnimationView.frame.size.width
        let height = virtualAnimationView.frame.size.height
        let animationFrame = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height  //virtualAnimationView.frame.size.height
        )
        lottieLogo.frame = animationFrame
        lottieLogo.clipsToBounds = true
        lottieLogo.contentMode = UIView.ContentMode.scaleToFill
        lottieLogo.loopAnimation = true
        virtualAnimationView.addSubview(lottieLogo)
        
        lottieLogo.play { (finished) in
            print ("Logo Starting")
            self.checkNextView()
        }
        
    }
    
    func isTutorialShowed() -> Bool {
        if AppInfo().isTutorialShowed != true {
            return false
        }else {
            return true
        }
    }
    
    func isUserLogin() -> Bool {
        if AppInfo().userName == "" && AppInfo().password == "" || AppInfo().userName == nil || AppInfo().phone == nil {
            return false
        }else {
            number = AppInfo().phone
            return true
        }
    }
    
    func finishLottie(){
        lottieLogo.loopAnimation = false
    }
    
    func isInternetConnection() {
        ReachabilityManager.isInternetAvailable() { (flag)  in
            print(flag)
            if flag {
                print("📡 Hay conexión a Internet 📡") // or do something here
                self.finishLottie()
            } else {
                print("☠️ No hay conexion a Internet ☠️") // or do something here
                self.showAlertNoInternet()
            }
        }
    }
    
    func checkNextView() {
        if isTutorialShowed() {
            switch flag {
            case 0:
                UIStoryboard.loadLogin()
            case 1:
                if AppInfo().isUserHost {
                    UIStoryboard.loadMenuHost()
                }else {
                    UIStoryboard.loadMenu()
                }
            default:
                break
            }
        }else {
            UIStoryboard.loadTutorial()
        }
    }
    
    func showAlertNoInternet(){
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "NoInternetConnectionViewController") as! NoInternetConnectionViewController
        self.view.addSubview(customAlert.view)
        
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
            self.isInternetConnection()
        }
    }
    
    func showAlertError(id: Int) {
        let iPhoneStoryboard = UIStoryboard.CustomAlerts()
        let customAlert = iPhoneStoryboard.instantiateViewController(withIdentifier: "ErrorNetworkingAlertViewController") as! ErrorNetworkingAlertViewController
        customAlert.id = id
        self.view.addSubview(customAlert.view)
        
        customAlert.handlerCloseView = {
            customAlert.view.removeFromSuperview()
        }
    }
    
    func startAnimation() {
        self.titleAnimation.translatesAutoresizingMaskIntoConstraints = true
        self.virtualAnimationView.translatesAutoresizingMaskIntoConstraints = true
        self.titleAnimation.alpha = 0.0
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.titleAnimation.frame = CGRect(x: self.virtualAnimationView.frame.maxX, y: self.titleAnimation.frame.origin.y, width: self.titleAnimation.frame.size.width, height: self.titleAnimation.frame.size.height)
            }, completion: { (finished: Bool) in
                if finished {
                    self.virtualAnimationView.sizeToFit()
                    self.titleAnimation.sizeToFit()
                    self.view.layoutSubviews()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.virtualAnimationView.frame = CGRect(x: self.virtualAnimationView.frame.origin.x, y: (abs(((self.virtualAnimationView.frame.size.height + self.titleAnimation.frame.size.height) - UIScreen.main.bounds.height) / 2)-25), width: self.virtualAnimationView.frame.size.width, height: self.virtualAnimationView.frame.size.height)
                        self.titleAnimation.isHidden = false
                        self.titleAnimation.frame = CGRect(x: ((UIScreen.main.bounds.width) / 2) - 70, y: self.virtualAnimationView.frame.maxY + 30, width: self.titleAnimation.frame.size.width, height: self.titleAnimation.frame.size.height)
                    }, completion: { (finished : Bool ) in
                        UIView.animate(withDuration: 1.0, animations: {
                            self.titleAnimation.alpha = 1.0
                        }, completion: { (finished : Bool ) in
                            if finished {
                                _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.validTimer), userInfo: nil, repeats: false)
                                
                            }
                        })
                    })
                }
            })
        }
    }
    
    func createBody() -> [String : Any] {
        var bodyCollection = [String : Any]()
        bodyCollection["userName"] = AppInfo().userName
        bodyCollection["password"] = AppInfo().password
        return bodyCollection
    }
    
    func checkGlobalMessages(message: String){
        if message != "" {
            print("Show Alert") //Desarrollar Alerta aopina
        }
    }
    
    func getToken() {
        APIVirtualLines.getToken().debug("APIVirtualLines.GetToken").subscribe(onNext: {(token) in
            print("📡 Hay conexión a Internet 📡")
            print ("onNext")
            print (token)
            AppInfo().token = token.access_token
            if self.isUserLogin() {
                self.login()
            }else {
                self.flag = 0
                self.resetLoopAnimation()
            }
        }, onError: {(error) in
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func login() {
        let parameters = createBody()
        let body = parameters
        APIVirtualLines.login(body: body).debug("APIVirtualLines.Login").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.checkGlobalMessages(message: dataResponse.globalMsg)
            if dataResponse.response?.code == 210 {
                self.flag = 1
                if dataResponse.category == 2 {
                    AppInfo().isUserHost = true
                }else {
                    AppInfo().isUserHost = false
                }
                self.getUserAddress()
            }
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.ErrorPassword(let error):
                print("Usuario Cambio Contraseña")//Desarrollar Alerta aopina
            case CatalogError.TokenRenew:
                self.login()
            case NetworkingError.Timeout:
                self.showAlertError(id: 0)
            case NetworkingError.NoInternet:
                self.showAlertError(id: 1)
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func getUserProfile() {
        APIVirtualLines.getUserProfile(number: number).debug("APIVirtualLines.GetUserProfile").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            AppInfo().nameUser = dataResponse.profileUser!.firstName
            self.resetLoopAnimation()
        }, onError: {(error) in
            self.resetLoopAnimation()
            switch error {
            case CatalogError.ErrorGeneral(let response):
                print("Error")
                //self.showAlertError(id: 2, text: response.message)
            case CatalogError.TokenRenew:
                self.getUserProfile()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func getUserAddress(){
        APIVirtualLines.getUserAddress(number: number).debug("getUserAddress").subscribe(onNext: {(dataResponse) in
            print("onNext")
            self.userLocations = dataResponse.locations!
            AppInfo().haveAddressUser = true
            self.getUserProfile()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.getUserAddress()
            case CatalogError.NotFoundPlaces:
                AppInfo().haveAddressUser = false
                self.resetLoopAnimation()
            default:
                break
            }
            print("onError")
            print (error)
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    @objc func validTimer() {
        self.isFinishedFlow = true
    }
    
    private func resetLoopAnimation() {
        self.lottieLogo.loopAnimation = false
        
    }
    
    
    
}


