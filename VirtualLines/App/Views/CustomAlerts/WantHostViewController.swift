//
//  WantHost.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class WantHostViewController: PopupAlertViewController {
    
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var handlerCloseView: () -> () = {}
    var handlerHostSignUp: () -> () = {}
    var handlerGoToMenu: () -> () = {}
    
    
    @IBAction func closeView(_ sender: Any) {
        self.close()
        UIView.animate(withDuration: 0.1, animations: {}, completion: { (finished : Bool) in
            if finished {
                print("finished",finished)
                self.handlerCloseView()
            }
        })
    }
    
    @IBAction func goToHost(_ sender: Any) {
        self.close()
        UIView.animate(withDuration: 0.1, animations: {}, completion: { (finished : Bool) in
            if finished {
                print("finished",finished)
                self.handlerHostSignUp()
            }
        })
    }
    
    @IBAction func goToMenuUser(_ sender: Any) {
        self.close()
        UIView.animate(withDuration: 0.1, animations: {}, completion: { (finished : Bool) in
            if finished {
                print("finished",finished)
                self.handlerGoToMenu()
            }
        })
    }
    
}
