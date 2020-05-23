//
//  VLUIView.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/12/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class NevUIView : UIView {
    
    var view: UIView!
    
    func viewSetup() {
        self.view = loadViewFromNib()
        
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(self.view)
    }
    
    func loadViewFromNib() -> UIView {
        
        guard let className = String(describing: type(of: self)).components(separatedBy:".").last
            else { return self }
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: className, bundle: bundle)
        let views = nib.instantiate(withOwner: self, options: nil)
        let view = views.first as! UIView
        return view
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewSetup()
    }
}
