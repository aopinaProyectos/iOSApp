//
//  PickerVirtualLines.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import ActionSheetPicker_3_0

protocol PickerVirtualLinesDelegate : class{
    func didSelect(_ sender:PickerVirtualLines, index:Int)
}

class PickerVirtualLines: NevUIView {
    @IBOutlet private weak var picketButton: UIButton!
    @IBOutlet weak var disclosure: UIImageView!
    @IBOutlet weak var value: UILabel!
    
    weak var delegate:PickerVirtualLinesDelegate?
    
    var items:[String]? {
        didSet {
            let item = items?.first ?? ""
            //picketButton.setTitle("\(name):", for: .normal)
            value.text = "\(item)"
            self.enabled = items?.count ?? 0 > 1
        }
    }
    
    @IBInspectable var enabled:Bool {
        get {
            return picketButton.isEnabled
        }
        set {
            self.picketButton.isEnabled = newValue
            self.disclosure.isHidden = !newValue
        }
    }
    
    @IBInspectable var pickerColor:UIColor {
        get {
            return value.textColor
        }
        set {
            self.value.textColor = newValue
            let image = UIImage(named: "Detalle")?.tinted(with: UIColor.white)
            disclosure.image = image
            self.picketButton.setTitleColor(newValue, for: .normal)
        }
    }
    
    var selectedItem:String? {
        didSet {
            guard let value = selectedItem else { return }
            
            let index = self.items?.index(of: value) ?? 0
            self.delegate?.didSelect(self, index: index)
            //self.picketButton.setTitle("\(self.name):", for: .normal)
            self.value.text = "\(value)"
        }
    }
    var pickerTitle:String?
    var name:String = "--"
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let items = self.items,
            items.count > 1 else { return }
        
        var initialSelection = 0
        if let item = self.selectedItem {
            initialSelection = items.index(of: item) ?? 0
        }
        
        let picker = ActionSheetStringPicker(title: pickerTitle, rows: items, initialSelection: initialSelection, doneBlock: { (picker, index, value) in
            self.selectedItem = value as? String
        }, cancel: nil, origin: self)
        picker?.setDoneButton(UIBarButtonItem(title: "Aceptar", style: .plain, target: nil, action: nil))
        picker?.setCancelButton(UIBarButtonItem(title: "Cancelar", style: .plain, target: nil, action: nil))
        
        picker?.show()
        
    }
    
}
