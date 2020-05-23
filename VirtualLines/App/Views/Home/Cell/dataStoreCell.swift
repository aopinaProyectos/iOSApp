//
//  dataStoreCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/26/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

let kDataStoreCellReuseIdentifier = "dataStoreCell"

protocol dataStoreDelegate : class {
    func imagePressed(image: UIButton)
    
    func favoritePressed(sender: UIButton)
}

class dataStoreCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imgPref1: UIImageView!
    @IBOutlet weak var imgPref2: UIImageView!
    @IBOutlet weak var imgPref3: UIImageView!
    
    var preferCount: Int = 0
    var arrayPreferences: [Preferences] = [Preferences]()
    
    weak var cellDelegate: dataStoreDelegate?
    
    override func awakeFromNib() {
        nameLabel.showAnimatedSkeleton()
        addressLabel.showAnimatedSkeleton()
        storeImage.showAnimatedSkeleton()
        distance.showAnimatedSkeleton()
        //timeRoad.showAnimatedSkeleton()
    }
    
    func hideAnimation() {
        nameLabel.hideSkeleton()
        addressLabel.hideSkeleton()
        //storeImage.hideSkeleton()
        distance.hideSkeleton()
        //timeRoad.hideSkeleton()
    }
    
    func setupView(name: String, address: String, category: Int) {
        nameLabel.text = name
        addressLabel.text = address
        switch category {
        case 1:
            storeImage.image = UIImage(named: "Banks")
        case 2:
            storeImage.image = UIImage(named: "Restaurants")
        case 3:
            storeImage.image = UIImage(named: "Enterteinment")
        case 4:
            storeImage.image = UIImage(named: "Health")
        case 5:
            storeImage.image = UIImage(named: "Education")
        case 6:
            storeImage.image = UIImage(named: "Pets")
        default:
            print("Descargar imagen de internet")
            
        }
    }
    
    func setupFavorite(store: DataStore, favorite: [String]){
        if favorite.count != 0 {
            for fav in favorite {
                if fav == "\(store.storeDetail!.id)" {
                    let image = resizeImage(image: UIImage(named: "Heart")!, targetSize: CGSize(width: 30, height: 30))
                    favoriteButton.setImage(image, for: .normal)
                    favoriteButton.isSelected = true
                    break
                }else {
                    let image = resizeImage(image: UIImage(named: "UnselectFav")!, targetSize: CGSize(width: 30, height: 30))
                    favoriteButton.setImage(image, for: .normal)
                }
            }
        }
    }
    
    func setupViewCell(store: DataStore) {
        let category = store.storeDetail?.storeCategoryId
        nameLabel.text = store.storeDetail?.name
        addressLabel.text = store.storeDetail?.storeAddress?.street
        let distanceinKm = store.distance / 1000
        distance.text = String(distanceinKm) + " km"
        rate.text = "\(store.storeDetail?.storeRating ?? 0)"
        
        switch getPreferences(pref: store.storeDetail!.preferences) {
        case 0:
            imgPref1.isHidden = true
            imgPref2.isHidden = true
            imgPref3.isHidden = true
        case 1:
            imgPref1.isHidden = false
            imgPref2.isHidden = true
            imgPref3.isHidden = true
            imgPref1.image = getImagePreference(id: arrayPreferences[0].preferencesId)
        case 2:
            imgPref1.isHidden = false
            imgPref2.isHidden = false
            imgPref3.isHidden = true
            imgPref1.image = getImagePreference(id: arrayPreferences[0].preferencesId)
            imgPref2.image = getImagePreference(id: arrayPreferences[1].preferencesId)
        case 3:
            imgPref1.isHidden = false
            imgPref2.isHidden = false
            imgPref3.isHidden = false
            imgPref1.image = getImagePreference(id: arrayPreferences[0].preferencesId)
            imgPref2.image = getImagePreference(id: arrayPreferences[1].preferencesId)
            imgPref3.image = getImagePreference(id: arrayPreferences[2].preferencesId)
        default:
            break
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        switch dayInWeek.lowercased() {
        case Message.MONDAY.localized.lowercased():
            schedule.text = (store.storeDetail?.schedules.monday)!
        case Message.TUESDAY.localized.lowercased():
            schedule.text = (store.storeDetail?.schedules.tuesday)!
        case Message.WEDNESDAY.localized.lowercased():
            schedule.text = (store.storeDetail?.schedules.wednesday)!
        case Message.THURSDAY.localized.lowercased():
            schedule.text = (store.storeDetail?.schedules.thursday)!
        case Message.FRIDAY.localized.lowercased():
            schedule.text = (store.storeDetail?.schedules.friday)!
        case Message.SATURDAY.localized.lowercased():
            schedule.text = (store.storeDetail?.schedules.saturday)!
        case Message.SUNDAY.localized.lowercased():
            schedule.text = (store.storeDetail?.schedules.sunday)!
        default:
            schedule.text = ""
        }
        if store.storeDetail!.images.count == 0 {
            viewImage.backgroundColor = .white
            storeImage.hideSkeleton()
            storeImage.image = imageBack(category: category!)
            storeImage.isHidden = false
        }else {
            downloadImage(url: (store.storeDetail?.images.first!.url)!, category: category!)
        }
        
        /*switch category {
        case 1:
            storeImage.image = UIImage(named: "Banks")
        case 2:
            storeImage.image = UIImage(named: "Restaurants")
        case 3:
            storeImage.image = UIImage(named: "Enterteinment")
        case 4:
            storeImage.image = UIImage(named: "Health")
        case 5:
            storeImage.image = UIImage(named: "Education")
        case 6:
            storeImage.image = UIImage(named: "Pets")
        default:
            print("Descargar imagen de internet")
            
        }*/
    }
    
    func getPreferences(pref: [Preferences]) -> Int {
        arrayPreferences = [Preferences]()
        if pref.count == 0 {
            return 0
        }else {
            for preference in pref {
                if preference.active {
                    arrayPreferences.append(preference)
                }
            }
            return arrayPreferences.count
        }
    }
    
    func getImagePreference(id: Int) -> UIImage {
        switch id {
        case 1:
            return UIImage(named: "Pet")!
        case 2:
            return UIImage(named: "Smoke")!
        case 3:
            return UIImage(named: "Meet")!
        default:
            return UIImage(named: "Meet")!
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
    
    @IBAction func imagePressed(_ sender: UIButton) {
        cellDelegate?.imagePressed(image: sender)
    }
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        cellDelegate?.favoritePressed(sender: sender)
    }
}
