//
//  ResponseVirtualLines.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Moya

public typealias JSONDictionary = [String: AnyObject]
public typealias VirtualLinesResponseType = (data: Data?, statusCode: Int?, response: URLResponse?, error: Swift.Error?)
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


public struct ErrorDescription {
    var code:Int
    var message:String
}

public struct VirtualLinesResponse {
    let response: VirtualLinesResponseType
    
    public init(response: VirtualLinesResponseType) {
        self.response = response
    }
    
    public func JSONResponse() -> Observable<JSONResult> {
        if let error = response.error as? NetworkingError {
            return Observable.just(Result.failure(error as Swift.Error))
        }
        
        guard let statusCode = response.statusCode else {
            return Observable.just(Result.failure(NetworkingError.NoSuccessStatusCode(httpStatusCode: 0, message: ErrorDescription(code: 0, message: "")) as Swift.Error))
        }
        
        guard ClosedRange(200...299).contains(statusCode) else {
            return Observable.just(Result.failure(NetworkingError.NoSuccessStatusCode(httpStatusCode: statusCode, message: getMessageFromJSON(data: response.data))))
        }
        
        guard let data = response.data, data.count > 0  else {
            return Observable.just(Result.failure(NetworkingError.NoData as Swift.Error))
        }
        
        do {
            return Observable.just(Result.success(try decodeJSON(data: data)))
        } catch {
            return Observable.just(Result.failure(NetworkingError.CouldNotParseJSON))
        }
    }
    
    public func arrayJSONResponse() -> Observable<ArrayJSONResult> {
        if let error = response.error as? NetworkingError {
            return Observable.just(Result.failure(error))
        }
        
        guard let statusCode = response.statusCode else {
            return Observable.just(Result.failure(NetworkingError.NoSuccessStatusCode(httpStatusCode: 0, message: ErrorDescription(code: 0, message: ""))))
        }
        
        guard ClosedRange(200...299).contains(statusCode) else {
            return Observable.just(Result.failure(NetworkingError.NoSuccessStatusCode(httpStatusCode: statusCode, message: getMessageFromJSON(data: response.data))))
        }
        
        guard let data = response.data else {
            return Observable.just(Result.failure(NetworkingError.NoData))
        }
        
        do {
            return Observable.just(Result.success(try decodeArrayJSON(data: data)))
        } catch {
            return Observable.just(Result.failure(NetworkingError.CouldNotParseJSON))
        }
    }
    
    public func decodeDataFile() -> Observable<DataFilePathResult> {
        if let error = response.error as? NetworkingError {
            return Observable.just(Result.failure(error))
        }
        
        guard let statusCode = response.statusCode else {
            return Observable.just(Result.failure(NetworkingError.NoSuccessStatusCode(httpStatusCode: 0, message: ErrorDescription(code: 0, message: ""))))
        }
        
        guard ClosedRange(200...299).contains(statusCode) else {
            return Observable.just(Result.failure(NetworkingError.NoSuccessStatusCode(httpStatusCode: statusCode, message: getMessageFromJSON(data: response.data))))
        }
        
        guard let data = response.data else {
            return Observable.just(Result.failure(NetworkingError.NoData))
        }
        
        do {
            return Observable.just(Result.success(try decodeDataFile(data: data)))
        } catch {
            return Observable.just(Result.failure(NetworkingError.NoData))
        }
    }
    
    private func getMessageFromJSON(data: Data?) -> ErrorDescription {
        do {
            let jsonData = try decodeJSON(data: data)
            var message : String? = jsonData["message"] as? String
            if(message == nil){
                message = jsonData["error"] as? String ?? "Error de conexión."
            }
            let code : Int = jsonData["status_code"] as? Int ?? 0
            return ErrorDescription(code: code, message: message!)
        } catch {
            return ErrorDescription(code: 0, message: "Error de conexión.")
        }
    }
    
    private func decodeJSON(data: Data?) throws -> JSONDictionary {
        guard let data = data else { throw NetworkingError.CouldNotParseJSON }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                return json
            } else {
                throw NetworkingError.CouldNotParseJSON
            }
        } catch {
            throw NetworkingError.CouldNotParseJSON
        }
    }
    
    private func decodeArrayJSON(data: Data) throws -> [JSONDictionary] {
        do {
            if let json = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? [JSONDictionary] {
                return json
            } else {
                throw NetworkingError.CouldNotParseJSON
            }
        } catch {
            throw NetworkingError.CouldNotParseJSON
        }
    }
    
}

extension ObservableType where E == Moya.Response {
    public func parseVLResponse() -> Observable<VirtualLinesResponse> {
        return flatMap { response -> Observable<VirtualLinesResponse> in
            let VirtualLinesRespType : VirtualLinesResponseType = (data: response.data, statusCode: response.statusCode, response: response.response, nil)
            let virtualLinesResponse = VirtualLinesResponse(response: virtualLinesRespType)
            return Observable.just(virtualLinesResponse)
        }
    }
}

extension ObservableType where E == VirtualLinesResponse {
    public func JSONResponse() -> Observable<JSONResult> {
        return flatMap { VirtualLinesResponse -> Observable<JSONResult> in
            return VirtualLinesResponse.JSONResponse()
        }
    }
    
    public func arrayJSONResponse() -> Observable<ArrayJSONResult> {
        return flatMap { VirtualLinesResponse -> Observable<ArrayJSONResult> in
            return VirtualLinesResponse.arrayJSONResponse()
        }
    }
    
    public func pathResponse() -> Observable<DataFilePathResult> {
        return flatMap { VirtualLinesResponse -> Observable<DataFilePathResult> in
            return VirtualLinesResponse.decodeDataFile()
        }
    }
}
