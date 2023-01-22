//
//  ChangePassword.swift
//  Post.e
//
//  Created by Scott Grivner on 10/31/22.
//

import Foundation
import Alamofire
import YPImagePicker
import NotificationBannerSwift

class ChangePassword: UIViewController {
    
    //Objects
    @IBOutlet var changePWTitle: UILabel!
    @IBOutlet var changePWCurrent: UITextField!
    @IBOutlet var changePWNew: UITextField!
    @IBOutlet var changePWReNew: UITextField!
    @IBOutlet var changePWBtn: UIButton!
    var instanceOfConstants = Constants()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTapped()
        
        changePWCurrent.clearButtonMode = .whileEditing
        changePWNew.clearButtonMode = .whileEditing
        changePWReNew.clearButtonMode = .whileEditing

        changePWCurrent.layer.cornerRadius = 10
        changePWNew.layer.cornerRadius = 10
        changePWReNew.layer.cornerRadius = 10
        changePWBtn.layer.cornerRadius = 10
        
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
    
    @IBAction func saveNewPassword(_ sender: Any) {
        
        if (changePWCurrent.text == "" || changePWNew.text == "" || changePWReNew.text == "") {
            
            let banner = NotificationBanner(title: "Warning!", subtitle: "All fields must be filled in!", style: .warning)
            banner.show()

            
        } else if (changePWNew.text != changePWReNew.text) {
            
            let banner = NotificationBanner(title: "Warning!", subtitle: "The two new entered Passwords don't match!", style: .warning)
            banner.show()
            
        } else if (changePWNew.text!.count < 8) {
            
            let banner = NotificationBanner(title: "Warning!", subtitle: "New Password is too short!", style: .warning)
            banner.show()
            
        } else if (changePWNew.text!.count > 45) {
            
            let banner = NotificationBanner(title: "Warning!", subtitle: "New Password is too long!", style: .warning)
            banner.show()
            
        } else {
            
            self.changePWBtn.isEnabled = false
            self.addLogoutOverlay(added:true)
            changePassword()
            
        }
        
    }
        
    func changePassword() {
            
        let url = instanceOfConstants.formatURL(LoginURL)
        
        let cur_password = self.changePWCurrent.text
        let new_password = self.changePWNew.text

        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                        
            let parameters: Parameters = ["cur_password": cur_password ?? "", "new_password": new_password ?? "", "command": "changePassword"]
            
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
                                
                                let deadlineTime = DispatchTime.now() + .seconds(1)
                                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                                    
                                    self.addLogoutOverlay(added:false)
                                    
                                    let banner = NotificationBanner(title: "Success!", subtitle: "Your Password has been successfully changed!", style: .success)
                                    banner.show()
                                    
                                    self.performSegue(withIdentifier: "Unwind_to_Profile_Edit", sender: self)
                                    
                                }
                                
                            } else if JSON["success"] as? Int == 0 {
                                
                                self.addLogoutOverlay(added:false)

                                let banner = NotificationBanner(title: "Warning!", subtitle: (JSON["error_message"] as! String), style: .warning)
                                banner.show()
                                
                                self.changePWBtn.isEnabled = true

                                
                            }
                            
                        }
                        
                        break
                        
                    case .failure(_):
                        
                        self.addLogoutOverlay(added:false)
                        
                        let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem changing your Password, please try again.", style: .danger)
                        banner.show()
                        
                        self.changePWBtn.isEnabled = true

                        break
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                
                self.changePWBtn.isEnabled = true
            }
        }
        
    }
}
