//
//  PopupAlertViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/2/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import UIKit

class PopupAlertViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    internal func show() {
        showAnimate()
    }
    
    internal func close() {
        hideAnimate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideAnimate()
    }
    
    private func showAnimate() {
        self.view.transform.scaledBy(x: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform.scaledBy(x: 1.0, y: 1.0)
        }
    }
    
    private func hideAnimate() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform.scaledBy(x: 1.3, y: 1.3)
                self.view.alpha = 0.0
            }, completion: { (finished : Bool) in
                if finished {
                    self.removeFromParent()
                    self.view.removeFromSuperview()
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
