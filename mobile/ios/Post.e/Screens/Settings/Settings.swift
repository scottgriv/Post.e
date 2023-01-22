//
//  Settings.swift
//  Post.e
//
//  Created by Scott Grivner on 5/16/22.
//

import UIKit
import Foundation
import Alamofire
import NotificationBannerSwift
import AudioToolbox.AudioServices


class Settings: UIViewController {
    
    //Variables
    var instanceOfConstants = Constants()
    var returnTitle: String!
    var returnSubtitle: String!
    
    @IBOutlet var aboutBtn: UIButton!
    @IBOutlet var libraryBtn: UIButton!
    @IBOutlet var languageBtn: UIButton!
    @IBOutlet var directoryBtn: UIButton!
    @IBOutlet var changePasswordBtn: UIButton!
    @IBOutlet var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutBtn.layer.cornerRadius = 10
        libraryBtn.layer.cornerRadius = 10
        languageBtn.layer.cornerRadius = 10
        directoryBtn.layer.cornerRadius = 10
        changePasswordBtn.layer.cornerRadius = 10
        logoutBtn.layer.cornerRadius = 10
        
        let directory = NSTemporaryDirectory()
        print(directory)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: NSLocalizedString("LOG_OUT", comment: ""), message: NSLocalizedString("LOG_OUT_MESSAGE", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("LOG_OUT", comment: ""), style: UIAlertAction.Style.destructive, handler: { [self] action in
            
            //Logout
            logout()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func clearTmpDir(){
        
        var removed: Int = 0
        do {
            let tmpDirURL = URL(string: NSTemporaryDirectory())!
            let tmpFiles = try FileManager.default.contentsOfDirectory(at: tmpDirURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            print("\(tmpFiles.count) temporary files found")
            for url in tmpFiles {
                removed += 1
                try FileManager.default.removeItem(at: url)
            }
            print("\(removed) temporary files removed")
        } catch {
            print(error)
            print("\(removed) temporary files removed")
        }
        
    }
    
    func addLogoutOverlay(added: Bool) {
        
        if (added) {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            dismiss(animated: false, completion: nil)
            
        }
        
    }
    
    func logout() {
        
        self.logoutBtn.isEnabled = false
        
        let url = instanceOfConstants.formatURL(LoginURL)
        let parameters = ["command": "Logout"]
        
        addLogoutOverlay(added:true)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        
            .responseJSON { [self] (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        
                        self.returnTitle = JSON["title"] as! String?
                        self.returnSubtitle = JSON["subtitle"] as! String?
                        
                        if JSON["success"] as? Int == 1 {
                            
                            clearTmpDir()
                            
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "tokenID")
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "token")
                            
                            let deadlineTime = DispatchTime.now() + .seconds(1)
                            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                                
                                let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
                                AudioServicesPlaySystemSound(vibrate)
                                
                                self.addLogoutOverlay(added:false)
                                
                                let banner = NotificationBanner(title: self.returnTitle, subtitle: self.returnSubtitle, style: .success)
                                
                                if (UserDefaults.standard.bool(forKey: "passThrough")) {
                                    
                                    self.performSegue(withIdentifier: "Settings_to_Login_Modally", sender: self)
                                    
                                    banner.show()
                                    
                                } else {
                                    
                                    self.performSegue(withIdentifier: "Settings_to_Login_Unwind", sender: self)
                                    
                                    banner.show()
                                    
                                }
                                
                            }
                            
                        } else if JSON["success"] as? Int == 0 {
                            
                            let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
                            AudioServicesPlaySystemSound(vibrate)
                            
                            addLogoutOverlay(added:false)
                            
                            let banner = NotificationBanner(title: self.returnTitle, subtitle: self.returnSubtitle, style: .danger)
                            banner.show()
                            
                            self.logoutBtn.isEnabled = true
                            
                        }
                        
                    }
                    
                    break
                    
                case .failure(_):
                    
                    let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
                    AudioServicesPlaySystemSound(vibrate)
                    
                    let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem logging in, please try again.", style: .danger)
                    banner.show()
                    
                    self.logoutBtn.isEnabled = true
                    
                    break
                    
                }
                
            }
        
    }
    
}
