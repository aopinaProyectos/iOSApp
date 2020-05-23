//
//  imageViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/15/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ImageSlideshow
import UIKit

let kImageCellReuseIdentifier = "imageViewCell"

protocol imageViewCellDelegate: class {
    func cameraTapped(_ tag: Int)
    func removeButton(_ tag: Int)
}

class imageViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonCamera: UIButton?
    @IBOutlet weak var labelIntructions: UILabel?
    @IBOutlet weak var viewSlideImages: ImageSlideshow!
    
    weak var cellDelegate: imageViewCellDelegate?
    
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
