//
//  ReachabilityManager.swift
//  VirtualLines
//
//  Created by Angel Omar Piña on 4/2/19.
//  Copyright © 2019 Apps Realities. All rights reserved.
//

import Reachability
import RxSwift
import Moya
import SystemConfiguration

class ReachabilityManager {
    
    private let hostnamePing : String = "www.google.com"
    private var reachability: Reachability?
    private var isMonitoring:Bool = false
    
    var isOnline : Bool = true
    static let sharedInstance = ReachabilityManager()
    
    private init() {
        self.reachability = Reachability(hostname: hostnamePing)
        
        self.reachability?.whenReachable = { reach in
            self.isOnline = true
        }
        
        self.reachability?.whenUnreachable = { reach in
            self.isOnline = false
        }
    }
    
    func startMonitoring() {
        do {
            if !self.isMonitoring {
                try self.reachability?.startNotifier()
                debugPrint("📡 Monitoreando la red!")
                self.isMonitoring = true
            }
        } catch {
            debugPrint("❌ No se pudo conectar a la red.")
        }
    }
    
    func stopMonitoring() {
        self.reachability?.stopNotifier()
        self.isMonitoring = false
        debugPrint("⛔ Se detuvo la conexion a la red!")
    }
    
    static func getWiFiAddress() -> String? {
        var address : String?
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }

    
    static func isInternetAvailable(completionHandler: @escaping (_ b: Bool) -> Void) {
        
        // 1. Checa conexion a la red
        guard isConnectedToNetwork() else {
            completionHandler(false)
            return
        }
        
        // 2. Checa la conexion a internet
        let webAddress = "https://www.google.com" // Default Web Site Ping
        
        guard let url = URL(string: webAddress) else {
            completionHandler(false)
            print("could not create url from: \(webAddress)")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil || response == nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        })
        
        task.resume()
    }
    
    
    
}

