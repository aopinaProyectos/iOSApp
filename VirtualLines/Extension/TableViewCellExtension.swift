//
//  TableViewCellExtension.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 5/13/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage!;
    }
    
}
