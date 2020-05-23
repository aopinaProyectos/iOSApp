//
//  ErrorAlertViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/7/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Lottie


class ErrorNetworkingAlertViewController: PopupAlertViewController {
    
    @IBOutlet weak var wifiAnimationView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var lottieLogo = LOTAnimationView()
    var handlerSplash: () -> () = {}
    var handlerRestart: () -> () = {}
    var isFinishedFlow : Bool = false
    var id = 0
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert(id: id, text: text)
        loadSplash()
        self.show()
    }
    
    var handlerCloseView: () -> () = {}
    
    
    func setupAlert(id: Int, text: String) {
        switch id {
        case 0:
            message.text = Message.INTERNETSLOW.localized
            lottieLogo = LOTAnimationView(name: "wifi")
        case 1:
            message.text = Message.NOINTERNETCONNECTION.localized
            lottieLogo = LOTAnimationView(name: "noconnection")
        case 2:
            message.text = text
            lottieLogo = LOTAnimationView(name: "error")
            button.setTitle(Message.ACCEPT.localized, for: .normal)
        case 3:
            message.text = text
            lottieLogo = LOTAnimationView(name: "passwordUpdate")
            button.setTitle(Message.ACCEPT.localized, for: .normal)
        case 4:
            message.text = text
            lottieLogo = LOTAnimationView(name: "profileUpdate")
            button.setTitle(Message.ACCEPT.localized, for: .normal)
        case 5:
            message.text = "Es necesario reiniciar la Aplicación"
            lottieLogo = LOTAnimationView(name: "restart")
            button.setTitle(Message.ACCEPT.localized, for: .normal)
        default:
            break
        }
        
    }
    
    func loadSplash() {
        let animationFrame = CGRect(
            x: 0,
            y: 0,
            width: wifiAnimationView.frame.size.width,
            height: wifiAnimationView.frame.size.height
        )
        lottieLogo.frame = animationFrame
        lottieLogo.clipsToBounds = true
        lottieLogo.contentMode = UIView.ContentMode.scaleAspectFit
        lottieLogo.loopAnimation = true
        wifiAnimationView.addSubview(lottieLogo)
        
        lottieLogo.play { (finished) in
            print ("Logo Starting")
        }
    }
    
    //Funciones para Botones
    @IBAction func closeView(_ sender: Any) {
        if id == 5 {
            self.handlerRestart()
            self.close()
        }else {
            self.handlerCloseView()
            self.close()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print()
    }
    
    
}
