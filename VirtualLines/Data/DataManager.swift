//
//  DataManager.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/11/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation

/**
 Generic protocol that allows the connection between the networkDataservice and the modules that perform the queries
 */
protocol DataManagerDelegate {
    
    /**
     Method that returns information from datamanager to iterator
     - returns: void
     - parameter response: Element coming from data manager of type T
     */
    func responseDataManager <T>(_ response: T)
}

