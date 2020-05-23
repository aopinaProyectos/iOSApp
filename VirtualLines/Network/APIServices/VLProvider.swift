//
//  VLProvider.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/9/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire
import Reachability

class VLProvider<T>: RXMoyaProvider<T> where T: TargetType {
    
    private let disposeBag = DisposeBag()
    internal var customManager : Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "18.223.117.118:8080": .disableEvaluation]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 120
        
        let man = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return man
    }()
    
    init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub,
         manager: Manager = Alamofire.SessionManager.default,
         plugins: [PluginType] = []) {
        
        var customM = manager
        customM = customManager
        
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: customM, plugins: plugins)
    }
    
    override func request(_ token: T) -> Observable<Moya.Response> {
        return _request(target: token)
    }
    
    private func _request(target: T, isSecondTryAfterAuth: Bool = false) -> Observable<Moya.Response> {
        return Observable.create { [weak self] observer in
            
            if ReachabilityManager.sharedInstance.isOnline {
                let cancellableToken = self?.request(target) { result in
                    switch result {
                    case let .success(response):
                        observer.onNext(response)
                        observer.onCompleted()
                        break
                    case let .failure(responseError):
                        if case .underlying(let error) = responseError {
                            switch (error as NSError).code {
                            case -1001:
                                observer.onError(NetworkingError.Timeout)
                            case 303:
                                observer.onError(NetworkingError.Timeout)
                            default:
                                observer.onError(responseError)
                            }
                        }
                    }
                }
                
                return Disposables.create {
                    cancellableToken?.cancel()
                }
            } else {
                observer.onError(NetworkingError.NoInternet)
                debugPrint("📡 No Internet")
                return Disposables.create {
                    
                }
            }
        }
    }
}

//Mark: - Network Struct
protocol NetworkingType {
    associatedtype T : TargetType
    var provider : VLProvider<T> { get }
}

struct Networking : NetworkingType {
    typealias T = APIVirtualLines
    let provider : VLProvider<T>
}

extension NetworkingType {
    static func endpointsClosure<T>() -> (T) -> Endpoint<T> where T:TargetType, T: Tokenable, T: ParameterEncodable {
        return { target in
            var endpoint : Endpoint<T> = Endpoint<T>(url: gburl(route: target), sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
            return endpoint
        }
    }
    
    static func requestClosure<T>() -> MoyaProvider<T>.RequestClosure where T: TargetType {
        return { (endpoint, closure) in
            var request: URLRequest = endpoint.urlRequest!
            request.httpShouldHandleCookies = false
            closure(.success(request))
        }
    }
    
    static func newInstance(stub: Bool = false) -> Networking {
        return Networking(provider: newProvider(stub: stub))
    }
    
}

private func gburl(route: TargetType) -> String {
    if route.path.isEmpty {
        return route.baseURL.absoluteString
    }
    
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

private func newProvider(stub: Bool) -> VLProvider<APIVirtualLines> {
    let stubClosure: MoyaProvider<APIVirtualLines>.StubClosure
    if stub {
        stubClosure = MoyaProvider.immediatelyStub
    } else {
        stubClosure = MoyaProvider.neverStub
    }
    return DominosProvider<APIVirtualLines>(endpointClosure: Networking.endpointsClosure(),
                                       requestClosure: Networking.requestClosure(),
                                       stubClosure: stubClosure)
}
