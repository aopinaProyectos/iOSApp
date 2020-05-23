//
//  tutorialShowViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/10/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class TutorialShowViewController: PopupAlertViewController {
    
    @IBOutlet weak var tutAnimationView: UIView!
    
    var lottieLogo = LOTAnimationView()
    var handlerSplash: () -> () = {}
    var isFinishedFlow : Bool = false
    var handlerCloseView: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieLogo = LOTAnimationView(name: "gesture")
        loadSplash()
        self.show()
    }
    
    func loadSplash() {
        let animationFrame = CGRect(
            x: 0,
            y: 0,
            width: tutAnimationView.frame.size.width,
            height: tutAnimationView.frame.size.height
        )
        lottieLogo.frame = animationFrame
        lottieLogo.clipsToBounds = true
        lottieLogo.contentMode = UIView.ContentMode.scaleAspectFit
        lottieLogo.loopAnimation = true
        tutAnimationView.addSubview(lottieLogo)
        
        lottieLogo.play { (finished) in
            print ("Logo Starting")
        }
    }
}
