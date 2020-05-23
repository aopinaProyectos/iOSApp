//
//  VirtualLinesResponse.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/10/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Moya

public typealias JSONDictionary = [String: AnyObject]
public typealias JSONResult = Result<JSONDictionary>
public typealias ArrayJSONResult = Result<[JSONDictionary]>
public typealias DataFilePathResult = Result<String>

public enum NetworkingError : Swift.Error {
    case CouldNotParseJSON
    case NoData
    case NoSuccessStatusCode(httpStatusCode: Int, message: ErrorDescription)
    case NoInternet
    case Unauthorized
    case Unknown
    case Timeout
    case Other(Swift.Error)
}

enum CatalogError : Swift.Error {
    case ErrorPassword(message: Response)
    case Unauthorized
    case TokenRenew
    case NotFoundPlaces
    case Unknown
    case NoLinesFound(message: Response)
    case ErrorChange(message: Response)
    case ErrorGeneral(message: Response)
}


public struct ErrorDescription {
    var code:Int
    var message:String
}
