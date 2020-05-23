//
//  dataRowViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/29/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

let kdataRowCellReuseIdentifier = "dataRowViewCell"

protocol cellDataRowDelegate : class {
    func pressStatus(sender: UIButton)
    func pressCancel(sender: UIButton)
}

class dataRowViewCell: UITableViewCell {
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var timeShift: UILabel!
    @IBOutlet weak var shiftNumber: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var cellDelegate: cellDataRowDelegate?
    
    func setupCell(info: ShiftRows, tag: Int, status: String) {
        storeName.text = info.store.store?.name
        storeAddress.text = info.store.store?.storeAddress?.street
        timeShift.text = info.shiftTime
        shiftNumber.text = info.shift
        statusLabel.isHidden = !info.next
        shareButton.tag = tag
        statusButton.tag = tag
        cancelButton.tag = tag
        if info.store.store?.images.count != 0 {
            downloadImage(url: (info.store.store?.images.first!.url)!, category: info.store.store!.storeCategoryId)
        } else {
            self.storeImage.image = imageBack(category: info.store.store!.storeCategoryId)
            self.storeImage.isHidden = false
        }
        switch status {
        case "VIGENTE":
            statusButton.setTitle("¿Llegaste?", for: .normal)
        case "CLIENTE EN EL NEGOCIO":
            statusButton.setTitle("¿Ya Pasaste?", for: .normal)
        default:
            break
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
    
    @IBAction func pressButton(_ sender: UIButton) {
        cellDelegate?.pressStatus(sender: sender)
    }
    
    @IBAction func pressCancel(_ sender: UIButton) {
        cellDelegate?.pressCancel(sender: sender)
    }
    
}
