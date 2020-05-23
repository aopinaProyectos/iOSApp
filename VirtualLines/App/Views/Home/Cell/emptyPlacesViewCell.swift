//
//  emptyPlacesViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/14/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Lottie

let kEmptyPlacesCellReuseIdentifier = "emptyPlacesViewCell"

class emptyPlacesViewCell: UITableViewCell {
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    let lottieLogo = LOTAnimationView(name: "emptyPlaces")
    let lottieLogoSearch = LOTAnimationView(name: "searchNot")
    var handlerSplash: () -> () = {}
    var isFinishedFlow : Bool = false
    
    func setupView(id: Int) {
        switch id {
        case 0:
            loadSplash()
        case 1:
            loadSplashSearch()
        default:
            break
        }
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
    
    func loadSplashSearch() {
        
        let animationFrame = CGRect(
            x: 0,
            y: 0,
            width: animationView.frame.size.width,
            height: animationView.frame.size.height
        )
        lottieLogoSearch.frame = animationFrame
        lottieLogoSearch.clipsToBounds = true
        lottieLogoSearch.contentMode = UIView.ContentMode.scaleAspectFit
        lottieLogoSearch.loopAnimation = true
        animationView.addSubview(lottieLogoSearch)
        
        lottieLogoSearch.play { (finished) in
            print ("Logo Starting")
        }
        
    }
}
