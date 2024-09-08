//
//  PassThrough.swift
//  Post.e
//
//  Created by Scott Grivner on 11/5/21.
//

import UIKit
import Alamofire
//import SnapKit
//import MarqueeLabel
import NotificationBannerSwift
import WatchConnectivity
//import NetworkManager


extension UINavigationController {
open override var prefersStatusBarHidden: Bool {
    return topViewController?.prefersStatusBarHidden ?? true
  }
}

class PassThrough: UIViewController, WCSessionDelegate {
    
    //Variables
    var window: UIWindow?
    var rootVC: String = "Login"
    var tokenID: String = ""
    var tokenString: String = ""
    var token: Int? = 0
    //var integrationFlag = false
    var instanceOfConstants = Constants()
    var language: String = ""
    let instanceOfAppInfo = AppInfo()
    let manager = NetworkReachabilityManager(host: LoginURL)
   
   // var statusBarHidden : Bool?

    override var prefersStatusBarHidden: Bool {
         return true
    }
    /*
    override var prefersStatusBarHidden: Bool {
        get {
            if let status = statusBarHidden { return status } else { return false }
        }
        set(status) {
            statusBarHidden = status
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        //prefersStatusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()

        print("App Name = \(instanceOfAppInfo.appName)")
        print("Version = \(instanceOfAppInfo.version)")
        print("Build = \(instanceOfAppInfo.build)")
        print("Minimum OS Version = \(instanceOfAppInfo.minimumOSVersion)")
        print("Copyright Notice = \(instanceOfAppInfo.copyrightNotice)")
        print("Bundle Identifier = \(instanceOfAppInfo.bundleIdentifier)")
        print("About Developer = \(instanceOfAppInfo.aboutDeveloper)")
        print("About Contact Email = \(instanceOfAppInfo.aboutContactEmail)")
        print("About Contact Website = \(instanceOfAppInfo.aboutContactWebsite)")
        print("Current Year = \(instanceOfAppInfo.currentYear)")
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
                
        self.language = UserDefaults.standard.object(forKey: "language") as? String ?? ""
        
        if (self.language == "") {
            
            UserDefaults.standard.set("php", forKey: "language")
            
        }
        
        // Pause on the Splash Screen
        // DispatchQueue.main.asyncAfter(deadline: .now() + 30) { // Adjust the time interval as needed
            self.passThrough()
        //}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PassThrough_to_Login" {
            
            UserDefaults.standard.set(false, forKey: "passThrough")
            
        } else if segue.identifier == "PassThrough_to_TabController" {
            
            UserDefaults.standard.set(true, forKey: "passThrough")
            
        }
    }
    
    func passThrough () {
        
        //Set Token ID
        if SSKeychain.password(forService: Bundle.main.bundleIdentifier, account: "tokenID") != nil {
            
            tokenID = SSKeychain.password(forService: Bundle.main.bundleIdentifier, account: "tokenID")
            
        }
        
        //Set User ID (Token)
        if SSKeychain.password(forService: Bundle.main.bundleIdentifier, account: "token") != nil {
            
            tokenString = SSKeychain.password(forService: Bundle.main.bundleIdentifier, account: "token")
        }
        
        token = Int(tokenString) ?? 0
        
        print("TokenID: \(tokenID), Token: \(String(describing: token))")
        
        if (!tokenID.isEmpty && token != 0) {
                        
            //Check if connected to the localhost
            if  (manager?.isReachableOnEthernetOrWiFi == true) {
                
                retrieveToken()
                
            } else {
                
                let banner = NotificationBanner(title: "Warning!", subtitle: "You're currently not connected to a network, please connect to your WiFi and try again.", style: .warning)
                banner.show()
                
                SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "tokenID")
                SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "token")
                
                self.performSegue(withIdentifier: "PassThrough_to_Login", sender: self)
            }
            
        } else {
            
            var delaySeconds = 0.0
            
            if (instanceOfAppInfo.delayLaunchScreen) {
                delaySeconds = 2.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) { // 2 seconds delay to show the Launch Screen
                self.performSegue(withIdentifier: "PassThrough_to_Login", sender: self)
            }
            
        }
        
    }
    
    func retrieveToken() {
        
        let url = instanceOfConstants.formatURL(LoginURL)
        let parameters = ["tokenID": tokenID, "command": "Session"]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        
                        print("Token: \(String(describing: JSON["token"]))")
                        print("TokenID: \(String(describing: JSON["tokenID"]))")
                        print("success: \(String(describing: JSON["success"]))")
                        
                        if JSON["success"] as? Int == 1 {
                            
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "tokenID")
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "token")
                            
                            SSKeychain.setPassword(JSON["tokenID"] as? String, forService: Bundle.main.bundleIdentifier, account: "tokenID")
                            SSKeychain.setPassword(String(JSON["token"] as? Int ?? 0), forService: Bundle.main.bundleIdentifier, account: "token")

                            if WCSession.default.isReachable {
                                
                                print("Valid Watch Session!")
                                
                                let data: [String: Any] =
                                ["token": self.tokenString as Any, "language": self.language as Any] // Create your Dictionay as per uses
                                WCSession.default.sendMessage(data, replyHandler: nil, errorHandler: nil)
                                
                            } else {
                                
                                print("Invalid Watch Session!")
                            }
                            
                            self.performSegue(withIdentifier: "PassThrough_to_TabController", sender: self)
                            
                            
                            
                        } else if JSON["success"] as? Int == 0 {
                            
                            let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem logging in, please try again.", style: .danger)
                            banner.show()
                            
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "tokenID")
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "token")
                            
                            self.performSegue(withIdentifier: "PassThrough_to_Login", sender: self)
                            
                        }
                        
                    }
                    
                    break
                    
                case .failure(_):
                    
                    let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem logging in, please try again.", style: .danger)
                    banner.show()
                    
                    SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "tokenID")
                    SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "token")
                    
                    self.performSegue(withIdentifier: "PassThrough_to_Login", sender: self)
                    
                    break
                    
                }
                
            }
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("received error: \(String(describing: error?.localizedDescription))")
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}
