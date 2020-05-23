//
//  CodeQRViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class CodeQRViewController: PopupAlertViewController {
    
    @IBOutlet weak var codeQRImage: UIImageView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var timeShiftLabel: UILabel!
    
    var shift: Shift = Shift()
    var storeName: String = ""
    var timeShift: String = ""
    var urlQR: String = ""
    
    
    var handlerCloseView: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeNameLabel.text = storeName
        timeShiftLabel.text = timeShift
        let jstr = shift.toJSONString()
        let cryptJson = stringToCrypto(text: jstr!)
        let image = generateQRCode(from: cryptJson)
        codeQRImage.image = image
        self.show()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.isoLatin1)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 100, y: 100)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }else {
                return nil
            }
        }
        return nil
    }
    
    func downloadImage(url: String) {
        let imageUrl = URL(string: url)
        Alamofire.request(imageUrl!, method: .get).responseImage { response in
            guard let image = response.result.value else {
                self.codeQRImage.isHidden = true
                return
            }
            let imageURL = self.resizeImage(image: image, targetSize: CGSize(width: 90, height: 90))
            self.codeQRImage.image = imageURL
        }
    }
    
    @IBAction func closeButton() {
        print ("ClosePressed")
        handlerCloseView()
        self.close()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handlerCloseView()
        self.close()
    }
}
