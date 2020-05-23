//
//  cameraImagesViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/11/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ImageSlideshow
import UIKit

let kCameraImagesCellReuseIdentifier = "cameraImagesViewCell"

protocol cameraImagesViewCellDelegate: class {
    func cameraTapped(_ tag: Int)
    func removeButton(_ tag: Int)
}

class cameraImagesViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonCamera: UIButton!
    @IBOutlet weak var viewSlideImages: ImageSlideshow!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var buttonRemove: UIButton!
    
    weak var cellDelegate: cameraImagesViewCellDelegate?
    
    func setupCell(flag: Bool) {
        if flag {
            let button = UIButton(type: .custom)
            let width = controlView.frame.size.width
            let height = controlView.frame.size.height
            button.frame = CGRect(x: (width / 2) - 40, y: (height / 2) - 20, width: 40, height: 40)
            
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.layer.borderWidth = 2
            button.layer.borderColor = kColorInactive.cgColor
            let image = resizeImage(image: UIImage(named: "Restaurants")!, targetSize: CGSize(width: 25, height: 25))
            button.setImage(image, for: .normal)
            controlView.addSubview(button)
        }
        
        controlView.borderColor = kColorInactive
        controlView.borderWidth = 2
        controlView.cornerRadius = 20
    }
    
    func configureSlideView(images: [UIImage]){
        var imageSour = [ImageSource]()
        for imag in images {
            imageSour.append(ImageSource(image: imag))
        }
        viewSlideImages.setImageInputs(imageSour)
        viewSlideImages.backgroundColor = UIColor.clear
        viewSlideImages.slideshowInterval = 5.0
        viewSlideImages.pageIndicatorPosition = PageIndicatorPosition.init()
        viewSlideImages.tintColor = kColorTabBar
        viewSlideImages.pageControl.pageIndicatorTintColor = UIColor.white
        viewSlideImages.contentScaleMode = UIView.ContentMode.scaleToFill
        
        viewSlideImages.currentPageChanged = { page in
            self.viewSlideImages.tag = page
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        cellDelegate?.cameraTapped(sender.tag)
    }
    
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        let index = viewSlideImages.currentPage
        cellDelegate?.removeButton(index)
    }
    
    
}
