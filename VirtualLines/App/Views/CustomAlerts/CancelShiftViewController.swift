//
//  CancelShiftViewController.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 6/16/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

class CancelShiftViewController: PopupAlertViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var pickerOptions: UIPickerView!
    
    var reason: [String] = []
    var reasonId: Int = 0
    
    var handlerCloseView: () -> () = {}
    var handlerGoToMenu: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.show()
        pickerOptions.delegate = self
        pickerOptions.dataSource = self
        reason = ["No creo llegar", "Cambio de Planes", "Problemas con la tienda", "Otra Razon"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reason.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reason[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        switch reason[row] {
        case reason[0]:
            reasonId = 2
        case reason[1]:
            reasonId = 3
        case reason[2]:
            reasonId = 6
        case reason[3]:
            reasonId = 7
        default:
            break
        }
    }
    
    @IBAction func closeButton(_ sender: UIButton!) {
        handlerGoToMenu()
        self.close()
    }
    
    
}
