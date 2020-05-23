//
//  CreateLineViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/20/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class CreateLineViewControlle: PopupAlertViewController {
    
    @IBOutlet weak var nameLineField: UITextField!
    @IBOutlet weak var minPeopleField: UITextField!
    @IBOutlet weak var minPeoButtonPlus: UIButton!
    @IBOutlet weak var minPeoButtonLess: UIButton!
    @IBOutlet weak var maxPeopleField: UITextField!
    @IBOutlet weak var maxPeoButtonPlus: UIButton!
    @IBOutlet weak var maxPeoButtonLess: UIButton!
    @IBOutlet weak var timeServiceField: UITextField!
    @IBOutlet weak var timeServicePlus: UIButton!
    @IBOutlet weak var timeServiceLess: UIButton!
    @IBOutlet weak var toleranceField: UITextField!
    @IBOutlet weak var tolerancePlus: UIButton!
    @IBOutlet weak var toleranceLess: UIButton!
    
    var iniMinPeople = 1
    var iniMaxPeople = 1
    var iniTS = 1
    var iniTolerance = 1
    
    var countMinPeople = 0
    var countMaxPeople = 0
    var countTS = 1
    var countTolerance = 1
    
    var flagUpdate = false
    
    var handlerCloseView: () -> () = {}
    var handlerCloseUpdateView: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.show()
        if flagUpdate {
            setupUpdate()
        }else {
            setupView()
        }
    }
    
    func setupUpdate() {
        nameLineField.text = AppInfo().lineName
        maxPeopleField.text = String(AppInfo().maxPeople)
        minPeopleField.text = String(AppInfo().minPeople)
        timeServiceField.text = String(AppInfo().TSTime) + " min"
        toleranceField.text = String(AppInfo().ToleranceTime) + " min"
        
        countMinPeople = AppInfo().minPeople
        countMaxPeople = AppInfo().maxPeople
        countTS = AppInfo().TSTime
        countTolerance = AppInfo().ToleranceTime
        
        flagUpdate = true
    }
    
    func setupView() {
        nameLineField.placeholder = "Ingresa el nombre de la linea"
        maxPeopleField.text = "0"
        minPeopleField.text = "0"
        timeServiceField.text = "1 min"
        toleranceField.text = "1 min"
        
        nameLineField.borderStyle = .none
        nameLineField.borderWidth = 0
        
        maxPeopleField.borderStyle = .none
        maxPeopleField.borderWidth = 0
        
        minPeopleField.borderStyle = .none
        minPeopleField.borderWidth = 0
        
        timeServiceField.borderStyle = .none
        timeServiceField.borderWidth = 0
        
        toleranceField.borderStyle = .none
        toleranceField.borderWidth = 0
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            countMinPeople = countMinPeople + 1
            if countMinPeople <= iniMinPeople {
                countMinPeople = iniMinPeople
                minPeopleField.text = String(countMinPeople)
            }else {
                minPeopleField.text = String(countMinPeople)
            }
        case 1:
            countMinPeople = countMinPeople - 1
            if countMinPeople <= iniMinPeople {
                countMinPeople = iniMinPeople
                minPeopleField.text = String(countMinPeople)
            }else {
                minPeopleField.text = String(countMinPeople)
            }
            
        case 2:
            countMaxPeople = countMaxPeople + 1
            if countMaxPeople <= iniMaxPeople {
                countMaxPeople = iniMaxPeople
                maxPeopleField.text = String(countMaxPeople)
            }else {
                maxPeopleField.text = String(countMaxPeople)
            }
        case 3:
            countMaxPeople = countMaxPeople - 1
            if countMaxPeople <= iniMaxPeople {
                countMaxPeople = iniMaxPeople
                maxPeopleField.text = String(countMaxPeople)
            }else {
                maxPeopleField.text = String(countMaxPeople)
            }
            
        case 4:
            countTS = countTS + 1
            if countTS <= iniTS {
                countTS = iniTS
                timeServiceField.text = String(countTS) + " min"
            }else {
                timeServiceField.text = String(countTS) + " min"
            }
        case 5:
            countTS = countTS - 1
            if countTS <= iniTS {
                countTS = iniTS
                timeServiceField.text = String(countTS) + " min"
            }else {
                timeServiceField.text = String(countTS) + " min"
            }
            
        case 6:
            countTolerance = countTolerance + 1
            if countTolerance <= iniTolerance {
                countTolerance = iniTolerance
                toleranceField.text = String(countTolerance) + " min"
            }else {
                toleranceField.text = String(countTolerance) + " min"
            }
        case 7:
            countTolerance = countTolerance - 1
            if countTolerance <= iniTolerance {
                countTolerance = iniTolerance
                toleranceField.text = String(countTolerance) + " min"
            }else {
                toleranceField.text = String(countTolerance) + " min"
            }
        default:
            break
        }
    }
    
    @IBAction func savePressed() {
        AppInfo().lineName = nameLineField.text!
        AppInfo().minPeople = countMinPeople
        AppInfo().maxPeople = countMaxPeople
        AppInfo().TSTime = countTS
        AppInfo().ToleranceTime = countTolerance
        if flagUpdate {
            handlerCloseUpdateView()
        }else {
            handlerCloseView()
        }
        self.close()
    }
    
}
