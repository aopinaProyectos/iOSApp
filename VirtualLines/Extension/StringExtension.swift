//
//  StringExtension.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/22/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    ///Variable that stores localized text
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    /**
     Returns localized text
     - parameter arguments: Data
     - returns: String
     */
    func localize(with arguments: CVarArg...) -> String{
        return String(format: self.localized, arguments: arguments)
    }
    
}


