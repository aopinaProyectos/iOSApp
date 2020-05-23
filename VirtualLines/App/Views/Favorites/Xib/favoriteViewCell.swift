//
//  favoriteViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/3/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import Alamofire
import AlamofireImage

let kFavoriteCellReuseIdentifier = "favoriteViewCell"

protocol cellFavoriteDelegate : class {
    func pressFavorite(sender: UIButton)
    func reloadTables(sender: UITapGestureRecognizer)
}

class favoriteViewCell: UITableViewCell {
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var animationFavorite: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var storeRate: UILabel!
    @IBOutlet weak var storeSchedule: UILabel!
    
    let lottieLogo = LOTAnimationView(name: "heart")
    var handlerSplash: () -> () = {}
    
    weak var cellDelegate: cellFavoriteDelegate?
    
    func setupCell(info: DataStore, tag: Int) {
        animationFavorite.tag = tag
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(targetViewDidTapped(sender:)))
        animationFavorite.addGestureRecognizer(gesture)
        heartInitial()
        storeName.text = info.storeDetail?.name
        storeAddress.text = info.storeDetail?.storeAddress?.street
        storeRate.text = "\(info.storeDetail?.storeRating ?? 0)"
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        switch dayInWeek.lowercased() {
        case Message.MONDAY.localized.lowercased():
            storeSchedule.text = (info.storeDetail?.schedules.monday)!
        case Message.TUESDAY.localized.lowercased():
            storeSchedule.text = (info.storeDetail?.schedules.tuesday)!
        case Message.WEDNESDAY.localized.lowercased():
            storeSchedule.text = (info.storeDetail?.schedules.wednesday)!
        case Message.THURSDAY.localized.lowercased():
            storeSchedule.text = (info.storeDetail?.schedules.thursday)!
        case Message.FRIDAY.localized.lowercased():
            storeSchedule.text = (info.storeDetail?.schedules.friday)!
        case Message.SATURDAY.localized.lowercased():
            storeSchedule.text = (info.storeDetail?.schedules.saturday)!
        case Message.SUNDAY.localized.lowercased():
            storeSchedule.text = (info.storeDetail?.schedules.sunday)!
        default:
            storeSchedule.text = ""
        }
        if info.storeDetail?.images.count != 0 {
            downloadImage(url: (info.storeDetail?.images.first!.url)!, category: info.storeDetail!.storeCategoryId)
        } else {
            self.storeImage.image = imageBack(category: info.storeDetail!.storeCategoryId)
            self.storeImage.isHidden = false
        }
        
    }
    
    func downloadImage(url: String, category: Int) {
        let imageUrl = URL(string: url)
        Alamofire.request(imageUrl!, method: .get).responseImage { response in
            guard let image = response.result.value else {
                self.storeImage.hideSkeleton()
                self.viewImage.backgroundColor = .white
                self.storeImage.image = self.imageBack(category: category)
                return
            }
            let imageURL = self.resizeImage(image: image, targetSize: CGSize(width: 90, height: 90))
            self.viewImage.backgroundColor = UIColor(patternImage: imageURL)
            self.storeImage.isHidden = true
            //self.storeImage.image = imageURL
            self.storeImage.hideSkeleton()
        }
    }
    
    func imageBack(category: Int) -> UIImage {
        switch category {
        case 1:
            return UIImage(named: "Banks")!
        case 2:
            return UIImage(named: "Restaurants")!
        case 3:
            return UIImage(named: "Enterteinment")!
        case 4:
            return UIImage(named: "Health")!
        case 5:
            return UIImage(named: "Education")!
        case 6:
            return UIImage(named: "Pets")!
        default:
            return UIImage(named: "Restaurants")!
        }
    }
    
    func heartInitial() {
        let animationFrame = CGRect(
            x: 0,
            y: 0,
            width: animationFavorite.frame.size.width,
            height: animationFavorite.frame.size.height
        )
        lottieLogo.frame = animationFrame
        lottieLogo.clipsToBounds = true
        lottieLogo.contentMode = UIView.ContentMode.scaleAspectFill
        lottieLogo.loopAnimation = true
        animationFavorite.addSubview(lottieLogo)
        lottieLogo.play(fromFrame: 5, toFrame: 5)
        lottieLogo.loopAnimation = false
    }
    
    @objc func targetViewDidTapped(sender: UITapGestureRecognizer) {
        lottieLogo.loopAnimation = false
        lottieLogo.play(fromFrame: 5, toFrame: 70) { (finished) in
            self.cellDelegate?.reloadTables(sender: sender)
        }
    }
    
    @IBAction func pressFavoriteButton(_ sender: UIButton) {
        cellDelegate?.pressFavorite(sender: sender)
    }
    
}
