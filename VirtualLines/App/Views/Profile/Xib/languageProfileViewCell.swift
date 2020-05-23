//
//  languageProfileViewCell.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 7/4/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

let kLanguageProfileViewCellReuseIdentifier = "languageProfileViewCell"

protocol cellLanguageProfileDelegate : class {
    func getAlert()
}

class languageProfileViewCell: UITableViewCell  {
    
    @IBOutlet weak var languages: PickerVirtualLines!
    @IBOutlet weak var titleLabel: UILabel!
    
    var languageSelected: String = ""
    var arrayLanguages: [String] = []
    var localeLang: String = ""
    var appbundle = Bundle.main
    var bundle: Bundle!
    
    var lin: [String]? {
        didSet {
            guard let line = self.lin,
                let lin = line.first
                else { return }
            
            self.languages.items = line
            self.languages.selectedItem = line.first
            self.languageSelected = line.first!
        }
    }
    
    weak var cellDelegate: cellLanguageProfileDelegate?
    
    func setupView() {
        arrayLanguages = []
        languages.delegate = self
        localeLang = NSLocale.current.languageCode!
        switch localeLang {
        case "es":
            arrayLanguages.append(Message.SPANISH.localized)
            arrayLanguages.append(Message.ENGLISH.localized)
        case "en":
            arrayLanguages.append(Message.ENGLISH.localized)
            arrayLanguages.append(Message.SPANISH.localized)
        default:
            break
        }
        lin = arrayLanguages
    }
    
    func setLanguage() {
        var prefix = ""
        switch languageSelected {
        case Message.SPANISH.localized:
            prefix = "es"
        case Message.ENGLISH.localized:
            prefix = "en"
        default:
            prefix = "es"
        }
        if localeLang != prefix {
            setSelectedLanguage(lang: prefix)
        }
    }
    
    func setSelectedLanguage(lang: String) {
        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        cellDelegate?.getAlert()
    }
    
}

extension languageProfileViewCell : PickerVirtualLinesDelegate {
    func didSelect(_ sender: PickerVirtualLines, index: Int) {
        if sender == self.languages {
            if languageSelected == "" {
                self.languageSelected = (lin?[index])!
            }else {
                self.languageSelected = (lin?[index])!
                setLanguage()
            }
        }
    }
}
