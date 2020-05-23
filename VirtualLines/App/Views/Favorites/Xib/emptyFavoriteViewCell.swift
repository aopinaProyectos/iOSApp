//
//  emptyFavoriteViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/3/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Lottie

let kEmptyFavoriteCellReuseIdentifier = "emptyFavoriteViewCell"

class emptyFavoriteViewCell: UITableViewCell {
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    let lottieLogo = LOTAnimationView(name: "fav")
    var handlerSplash: () -> () = {}
    var isFinishedFlow : Bool = false
    
    func setupView() {
        loadSplash()
    }
    
    func loadSplash() {
        
        let animationFrame = CGRect(
            x: 0,
            y: 0,
            width: animationView.frame.size.width,
            height: animationView.frame.size.height
        )
        lottieLogo.frame = animationFrame
        lottieLogo.clipsToBounds = true
        lottieLogo.contentMode = UIView.ContentMode.scaleAspectFit
        lottieLogo.loopAnimation = true
        animationView.addSubview(lottieLogo)
        
        lottieLogo.play { (finished) in
            print ("Logo Starting")
        }
        
    }
}
