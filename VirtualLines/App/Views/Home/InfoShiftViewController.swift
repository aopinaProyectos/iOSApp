//
//  InfoShiftViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 7/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit
import Pulley
import RxSwift
import Alamofire
import AlamofireImage

class InfoShiftViewController: UIViewController {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var waitShiftLabel: UILabel!
    @IBOutlet weak var timeWaitLabel: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var linePicker: PickerVirtualLines!
    @IBOutlet weak var lightWait: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var storeId: Int = 0
    var phone = AppInfo().phone
    
    var stores: DataStore = DataStore()
    var lineSelected: InfoShift = InfoShift()
    var lines: [InfoShift] = [InfoShift]()
    var placeFavorite: Favorites = Favorites()
    var arrayFav: [String] = [String]()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var lin: [InfoShift]? {
        didSet {
            guard let line = self.lin,
                let lin = line.first
                else { return }
            
            self.linePicker.items = line.map { $0.name }
            self.linePicker.selectedItem = line.first?.name
            self.lineSelected = line.first!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linePicker.delegate = self
        getInfoLine()
    }
    
    func setupMaster() {
        storeId = stores.storeDetail!.id
        checkFavorites()
        self.getInfoLine()
    }
    
    func setupView() {
        storeName.text = stores.storeDetail?.name
        storeAddress.text = stores.storeDetail?.storeAddress?.street
        if stores.storeDetail?.images.count != 0 {
            downloadImage(url: (stores.storeDetail?.images.first!.url)!, category: stores.storeDetail!.storeCategoryId)
        }else {
            self.viewImage.backgroundColor = .white
            self.storeImage.image = self.imageBack(category: stores.storeDetail!.storeCategoryId)
            self.storeImage.isHidden = false
        }
        capacityLabel.text = String(lineSelected.serviceLimit)
        waitShiftLabel.text = String(lineSelected.shifts)
        timeWaitLabel.text = String(lineSelected.serviceWaitTime)
        rateLabel.text = "\(stores.storeDetail?.storeRating ?? 0)"
        checkTimes()
        checkSchedule()
    }
    
    func checkSchedule() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        switch dayInWeek.lowercased() {
        case Message.MONDAY.localized.lowercased():
            schedule.text = (stores.storeDetail?.schedules.monday)!
        case Message.TUESDAY.localized.lowercased():
            schedule.text = (stores.storeDetail?.schedules.tuesday)!
        case Message.WEDNESDAY.localized.lowercased():
            schedule.text = (stores.storeDetail?.schedules.wednesday)!
        case Message.THURSDAY.localized.lowercased():
            schedule.text = (stores.storeDetail?.schedules.thursday)!
        case Message.FRIDAY.localized.lowercased():
            schedule.text = (stores.storeDetail?.schedules.friday)!
        case Message.SATURDAY.localized.lowercased():
            schedule.text = (stores.storeDetail?.schedules.saturday)!
        case Message.SUNDAY.localized.lowercased():
            schedule.text = (stores.storeDetail?.schedules.sunday)!
        default:
            schedule.text = ""
        }
    }
    
    func checkFavorites() {
        self.arrayFav = AppInfo().arrayFavorites!
        for fav in arrayFav {
            if fav == "\(stores.storeDetail?.id ?? 0)" {
                favoriteButton.isSelected = true
                favoriteButton.setImage(UIImage(named: "Heart"), for: .normal)
                break
            }else {
                favoriteButton.isSelected = false
            }
        }
    }
    
    func checkTimes() {
        if lineSelected.shifts > lineSelected.serviceLimit {
            if lineSelected.shifts > (lineSelected.serviceLimit * 2) {
                lightWait.backgroundColor = .red
            }else {
                lightWait.backgroundColor = .yellow
            }
        }else {
            lightWait.backgroundColor = .green
        }
    }
    
    func setupDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        dateLabel.text = myString
    }
    
    func getInfoLine() {
        APIVirtualLines.getInfoShift(storeId: self.storeId).debug("APIVirtualLines.getInfoLine").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            self.lin = dataResponse.virtualLines!
            self.lines = dataResponse.virtualLines!
            self.setupView()
        }, onError: {(error) in
            print("onError")
            switch error {
            case CatalogError.TokenRenew:
                self.getTokenRenew()
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func setFavoritePlace() {
        APIVirtualLines.setFavorite(number: self.phone, body: self.placeFavorite).debug("APIVirtualLines.SetFavoritePlace").subscribe(onNext: {(dataResponse) in
            print ("onNext")
            AppInfo().arrayFavorites = self.arrayFav
            self.checkFavorites()
            //self.tableView.reloadData()
        }, onError: {(error) in
            switch error {
            case CatalogError.TokenRenew:
                self.setFavoritePlace()
            case CatalogError.ErrorGeneral(let response):
                //self.showAlertError(id: 2, text: response.message)
                print ("Error")
            default:
                break
            }
        }, onCompleted: {
            print ("Completed")
        }).disposed(by: disposeBag)
    }
    
    func downloadImage(url: String, category: Int) {
        let imageUrl = URL(string: url)
        Alamofire.request(imageUrl!, method: .get).responseImage { response in
            guard let image = response.result.value else {
                self.viewImage.backgroundColor = .white
                self.storeImage.image = self.imageBack(category: category)
                return
            }
            let imageURL = self.resizeImage(image: image, targetSize: CGSize(width: 90, height: 90))
            self.viewImage.backgroundColor = UIColor(patternImage: imageURL)
            self.storeImage.isHidden = true
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
    
    func getShift() {
        let master = parent as! PreviewShiftViewController
        master.lineSelected = self.lineSelected
        master.getShift()
    }
    
    @IBAction func getShiftPressed(sender: UIButton){
        getShift()
    }
    
    @IBAction func favoritePressed(sender: UIButton) {
        placeFavorite.favorites.status = !sender.isSelected
        placeFavorite.favorites.storeId = stores.storeDetail!.id
        self.arrayFav.append("\(stores.storeDetail!.id)")
        setFavoritePlace()
    }
    
    @IBAction func schedulePressed(_ sender: UIButton) {
        let master = parent as! PreviewShiftViewController
        master.showPickerDate(sender: sender)
    }
    
}

extension InfoShiftViewController : PickerVirtualLinesDelegate {
    func didSelect(_ sender: PickerVirtualLines, index: Int) {
        if sender == self.linePicker {
            self.lineSelected = (lin?[index])!
            self.setupView()
        }
    }
}

extension InfoShiftViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 50.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 420.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
}
