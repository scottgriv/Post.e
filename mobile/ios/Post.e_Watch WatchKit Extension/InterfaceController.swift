//
//  InterfaceController.swift
//  Post.e_Watch WatchKit Extension
//
//  Created by Scott Grivner on 7/8/22.
//

import WatchKit
import Foundation
import Alamofire
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var postInputBtn: WKInterfaceButton!
    @IBOutlet var postTxt: WKInterfaceLabel!
    @IBOutlet var postBtn: WKInterfaceButton!
    var postTxtString: String!
    var tokenString: String = ""
    var token: Int? = 0
    var language: String = ""
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("Session has been activated")
            
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func postInputClicked() {
        
        self.presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji, completion: {results in
            
            guard let results = results else { return }
            
            OperationQueue.main.addOperation {
                
                self.dismissTextInputController()
                
                self.postTxt.setText(results[0] as? String)
                self.postTxtString = results[0] as? String
                
                if (self.postTxtString == "") {
                    
                    self.postTxt.setText("Post Something!")
                    
                }
                
            }
            
        })
        
    }
    
    @IBAction func postClicked() {
        
        print("Post Clicked! - ", self.postTxtString ?? "")
        
        sendPost(postTxt: self.postTxtString ?? "")
        
    }
    
    func sendPost(postTxt: String) {
        
        postBtn.setEnabled(false)
        
        self.language = UserDefaults.standard.object(forKey: "language") as? String ?? "php" //default to using php.
        self.tokenString = UserDefaults.standard.object(forKey: "token") as? String ?? "" //hardcode a Profile_ID to Test (i.e. "1").
        
        print("Language: \(String(describing: self.language))")
        print("Token String: \(String(describing: self.tokenString))")
        
        if (postTxt == "") {
            
            self.postTxt.setText("Click Input Post!")
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                self.clearText()
            }
            
        } else if (self.tokenString == "") {
            
            self.postTxt.setText("Open Post.e on your Phone First!")
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                self.clearText()
            }
            
        } else {
            
            let url = "http://localhost/Post.e/server/languages/\(self.language)/post.php"
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                let parameters: Parameters = ["profile_ID": self.tokenString, "post": postTxt, "type": "Watch", "command": "createPost"]
                
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, to: url, method: .post) { (encodingResult) in
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    upload.responseJSON { (response) in
                        
                        switch(response.result) {
                        case .success(_):
                            
                            if let result = response.result.value {
                                let JSON = result as! NSDictionary
                                
                                print("Success: \(String(describing: JSON["success"]))")
                                print("Error Message: \(String(describing: JSON["error_message"]))")
                                
                                if JSON["success"] as? Int == 1 {
                                    
                                    self.postTxt.setText("Post Success!")
                                    
                                    WKInterfaceDevice.current().play(.success)
                                    //WKInterfaceDevice.currentDevice().playHaptic(.Click)
                                    
                                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                                        self.clearText()
                                    }
                                    
                                } else if JSON["success"] as? Int == 0 {
                                    
                                    self.postTxt.setText("Post Error, Try Again!")
                                    
                                    WKInterfaceDevice.current().play(.failure)
                                    
                                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                                        self.clearText()
                                    }
                                    
                                }
                                
                            }
                            
                            break
                            
                        case .failure(_):
                            
                            self.postTxt.setText("Error Connecting to Server!")
                            
                            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                                self.clearText()
                            }
                            
                            break
                            
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                    
                    self.postTxt.setText("Error Connecting to Server!")
                    
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                        self.clearText()
                    }
                }
            }
            
        }
        
        
    }
    
    func clearText() {
        
        self.postTxt.setText("Post Something!")
        self.postTxtString = ""
        postBtn.setEnabled(true)
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        print("received data: \(message)")
        
        if let tokenValue = message["token"] as? String {
            
            UserDefaults.standard.set(tokenValue, forKey: "token")
            
        }
        
        if let languageValue = message["language"] as? String {
            
            UserDefaults.standard.set(languageValue, forKey: "language")
            
        }
        
    }
    
}
