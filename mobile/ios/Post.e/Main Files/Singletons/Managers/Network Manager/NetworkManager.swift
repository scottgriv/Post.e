//
//  NetworkManager.swift
//  Post.e
//
//  Created by Scott Grivner on 9/6/22.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    let manager = NetworkReachabilityManager(host: LoginURL)
    fileprivate var isInternetReachable = false
    
    func startMonitoring() {
        
        self.manager?.listener = { status in
            
            if self.manager?.isReachable ?? false {
                
                switch status {
                    
                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")
                    self.isInternetReachable = true

                case .reachable(.wwan):
                    print("The network is reachable over the WWAN connection")
                    self.isInternetReachable = true

                case .notReachable:
                    print("The network is not reachable")
                    self.isInternetReachable = false

                case .unknown :
                    print("It is unknown whether the network is reachable")
                    self.isInternetReachable = false

                }
            }
            
            self.manager?.startListening()
            
        }
        
    }
    
}
