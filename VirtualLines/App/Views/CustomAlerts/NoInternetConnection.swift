//
//  NoInternetConnection.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/2/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import UIKit
import Lottie


class NoInternetConnectionViewController: PopupAlertViewController {
    
    @IBOutlet weak var wifiAnimationView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let lottieLogo = LOTAnimationView(name: "wifi")
    var handlerSplash: () -> () = {}
    var isFinishedFlow : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSplash()
        self.show()
    }
    
    var handlerCloseView: () -> () = {}
    
    
    func setupAlert() {
        button.titleLabel?.text = NSLocalizedString("RETRY", comment: "Button")
        message.text = NSLocalizedString("NOINTERNET", comment: "Alert")
        
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
