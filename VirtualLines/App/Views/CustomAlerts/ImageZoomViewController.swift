//
//  ImageZoomViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/22/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import Alamofire
import AlamofireImage


class ImageZoomViewController: PopupAlertViewController {
    
    @IBOutlet weak var viewSlideImages: ImageSlideshow!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    var images: [images] = []
    var imagess: [UIImage] = []
    var category: Int = 0
    var imagesSource = [InputSource]()
    
    var handlerSplash: () -> () = {}
    var handlerCloseView: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()
        setupAlert()
        self.show()
    }
    
    func setupAlert() {
        configureSlideView()
    }
    
    func getImages() {
        if images.count == 0 {
            let image = imageBack(category: category)
            imagesSource.append(ImageSource(image: image))
        }else {
            for image in images {
                downloadImage(url: image.url, category: category)
            }
        }
    }
    
    func downloadImage(url: String, category: Int) {
        let imageUrl = URL(string: url)
        Alamofire.request(imageUrl!, method: .get).responseImage { response in
            guard let image = response.result.value else {
                self.imagesSource.append(ImageSource(image: self.imageBack(category: category)))
                self.configureSlideView()
                return
            }
            let imageURL = self.resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
            self.imagesSource.append(ImageSource(image: imageURL))
            self.configureSlideView()
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
    
    private func configureSlideView(){
        viewSlideImages.setImageInputs(imagesSource)
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
    
    //Funciones para Botones
    @IBAction func closeView(_ sender: Any) {
        self.handlerCloseView()
        self.close()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.close()
    }
    
    
}
