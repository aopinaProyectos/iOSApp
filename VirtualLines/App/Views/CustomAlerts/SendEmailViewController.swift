//
//  SendEmailViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/30/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Lottie


class SendEmailViewController: PopupAlertViewController {
    
    @IBOutlet weak var wifiAnimationView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var lottieLogo = LOTAnimationView()
    var handlerSplash: () -> () = {}
    var isFinishedFlow : Bool = false
    var id = 0
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
        loadSplash()
        self.show()
    }
    
    var handlerCloseView: () -> () = {}
    
    
    func setupAlert() {
        message.text = text
        lottieLogo = LOTAnimationView(name: "email")
        button.setTitle(Message.ACCEPT.localized, for: .normal)
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
        lottieLogo.contentMode = UIView.ContentMode.scaleAspectFill
        lottieLogo.loopAnimation = true
        wifiAnimationView.addSubview(lottieLogo)
        
        lottieLogo.play { (finished) in
            print ("Logo Starting")
        }
    }
    
    //Funciones para Botones
    @IBAction func closeView(_ sender: Any) {
        self.handlerCloseView()
        self.close()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print()
    }
}
