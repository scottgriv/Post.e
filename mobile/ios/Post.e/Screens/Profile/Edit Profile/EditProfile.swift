//
//  EditProfile.swift
//  Post.e
//
//  Created by Scott Grivner on 4/11/22.
//

import Foundation
import Alamofire
import YPImagePicker
import NotificationBannerSwift

class EditProfile: UIViewController {
    
    //Objects
    @IBOutlet var editProfPicImgVw: UIImageView!
    @IBOutlet var editProfChangePhotoBtn: UIButton!
    @IBOutlet var editProfRemovePhotoBtn: UIButton!
    @IBOutlet var editProfUserTxtFld: UITextField!
    @IBOutlet var editProfNameTxtFld: UITextField!
    @IBOutlet var editProfSaveBtn: UIButton!
    @IBOutlet var editProfDeleteBtn: UIButton!
    @IBOutlet var editProfLoadingAI: UIActivityIndicatorView!
    
    //Variables
    @objc var editProfID: Int = 0
    @objc var editProfUser: String!
    @objc var editProfName: String!
    @objc var editProfPic: String!
    
    var editPicFile: Data!
    var editPicFilePath: URL!
    var editPicFileName: String!
    var returnTitle: String!
    var returnSubtitle: String!
    var changesMadePic = false
    var changesMadeFields = false
    var myDataManager = DataManager()
    var instanceOfConstants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTapped()
        
        editProfChangePhotoBtn.layer.cornerRadius = 10
        editProfRemovePhotoBtn.layer.cornerRadius = 10
        editProfSaveBtn.layer.cornerRadius = 10
        editProfDeleteBtn.layer.cornerRadius = 10
        
        editProfUserTxtFld.text = editProfUser
        editProfNameTxtFld.text = editProfName
        
        self.editProfRemovePhotoBtn.isEnabled = false
        self.editProfLoadingAI.startAnimating()
        
        self.editProfPicImgVw.layer.masksToBounds = true
        self.editProfPicImgVw.layer.cornerRadius = self.editProfPicImgVw.frame.size.width / 2
        self.editProfPicImgVw.image = UIImage(named:"Default_Prof.png")
        //self.editProfPicImgVw.clipsToBounds = true
        
        self.editProfUserTxtFld.addTarget(self, action: #selector(EditProfile.textFieldDidChange(_:)),
                                          for: .editingChanged)
        
        self.editProfNameTxtFld.addTarget(self, action: #selector(EditProfile.textFieldDidChange(_:)),
                                          for: .editingChanged)
        
        self.editProfPicImgVw.contentMode = .scaleAspectFill
        
        if (self.editProfPic != nil) {
            
            Alamofire.request(self.editProfPic, method: .get)
                .validate()
                .downloadProgress { (progress) in
                }
                .responseData(completionHandler: { (responseData) in
                    
                    self.editProfPicImgVw.image = UIImage(data: responseData.data!)
                    
                    print("File Path: \(String(describing: self.editProfPic))")
                    
                    self.editProfLoadingAI.stopAnimating()
                    self.editProfLoadingAI.isHidden = true
                    
                    DispatchQueue.main.async {
                        // Refresh you views
                    }
                })
            
            self.editProfRemovePhotoBtn.isEnabled = true
            
            
        } else {
            
            self.editProfLoadingAI.stopAnimating()
            self.editProfLoadingAI.isHidden = true
            self.editProfRemovePhotoBtn.isEnabled = false
            
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        changesMadeFields = true
        
    }
    
    @IBAction func changeProfPicClicked(_ sender: Any) {
        
        self.editProfChangePhotoBtn.isEnabled = false
        
        changesMadePic = true
        
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.shouldSaveNewPicturesToAlbum = true
        config.screens = [.library, .photo]
        config.library.mediaType = .photo
        config.usesFrontCamera = true
        config.showsPhotoFilters = true
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                //print(photo.modifiedImage) // Transformed image, can be nil
                //print(photo.exifMeta) // Print exif meta data of original image.
                
                self.editPicFileName = String(self.editProfID) + ".jpg"
                var imgData : Data!
                
                if photo.modifiedImage != nil {
                    imgData = photo.modifiedImage?.jpegData(compressionQuality: 1.0)
                } else {
                    imgData = photo.originalImage.jpegData(compressionQuality: 1.0)
                }
                
                debugPrint("Size of Image: \(imgData!.count) bytes")
                self.editPicFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(self.editPicFileName)
                try? imgData!.write(to: self.editPicFilePath)
                
                print("Attachment File Path:")
                print(self.editPicFilePath!); //URL
                
                self.editProfPicImgVw.image = UIImage(data: imgData)
                self.editPicFile = imgData
                self.editProfRemovePhotoBtn.isEnabled = true
                
            }
            
            picker.dismiss(animated: true, completion: nil)
            self.editProfChangePhotoBtn.isEnabled = true
            
        }
        present(picker, animated: true, completion: nil)
        self.editProfChangePhotoBtn.isEnabled = true
        
    }
    
    @IBAction func removeProfPicClicked(_ sender: Any) {
        
        self.editProfRemovePhotoBtn.isEnabled = false
        self.editProfPicImgVw.image = UIImage(named:"Default_Prof.png")
        self.editProfLoadingAI.startAnimating()
        
        let url = instanceOfConstants.formatURL(ProfileURL)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let parameters: Parameters = ["command": "removeProfPic"]
            
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
                                
                                let banner = NotificationBanner(title: "Success!", subtitle: "Your Profile Photo has been successfully removed!", style: .success)
                                banner.show()
                                
                                self.performSegue(withIdentifier: "Unwind_to_Profile_Edit", sender: self)
                                
                            } else if JSON["success"] as? Int == 0 {
                                
                                let banner = NotificationBanner(title: "Error!", subtitle: (JSON["error_message"] as! String), style: .danger)
                                banner.show()
                                self.editProfRemovePhotoBtn.isEnabled = true
                                
                                
                            }
                            
                        }
                        
                        break
                        
                    case .failure(_):
                        
                        let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem removing your Profile Picture, please try again.", style: .danger)
                        banner.show()
                        self.editProfRemovePhotoBtn.isEnabled = true
                        
                        break
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
        }
        
        self.editProfLoadingAI.stopAnimating()
        self.editProfLoadingAI.isHidden = true
        
    }
    
    @IBAction func saveChangesClicked(_ sender: Any) {
        print("Save Clicked!")
        
        if (changesMadePic || changesMadeFields) {
            
            self.addOverlay(added:true)
            
            self.editProfSaveBtn.isEnabled = false
            
            var userVar: String?
            var nameVar: String?
            
            userVar = self.editProfUserTxtFld.text
            nameVar = self.editProfNameTxtFld.text
            
            let url = instanceOfConstants.formatURL(ProfileURL)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if (self.changesMadeFields && self.changesMadePic) {
                    
                    multipartFormData.append(self.editPicFile, withName: String(self.editProfID), fileName: self.editPicFileName, mimeType: "image/jpeg")
                    
                    let parameters: Parameters = ["profile_user": userVar ?? "", "profile_name": nameVar ?? "", "changes_fields": self.changesMadeFields, "changes_pic": self.changesMadePic, "command": "editProfile"]
                    
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                } else if (self.changesMadeFields && !self.changesMadePic) {
                    
                    let parameters: Parameters = ["profile_user": userVar ?? "", "profile_name": nameVar ?? "", "changes_fields": self.changesMadeFields, "changes_pic": self.changesMadePic, "command": "editProfile"]
                    
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                } else if (!self.changesMadeFields && self.changesMadePic) {
                    
                    multipartFormData.append(self.editPicFile, withName: String(self.editProfID), fileName: self.editPicFileName, mimeType: "image/jpeg")
                    
                    let parameters: Parameters = ["changes_fields": self.changesMadeFields, "changes_pic": self.changesMadePic, "command": "editProfile"]
                    
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
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
                                    
                                    let banner = NotificationBanner(title: "Success!", subtitle: "Your Profile has been successfully updated!", style: .success)
                                    banner.show()
                                    
                                    self.addOverlay(added:false)
                                    //self.performSegue(withIdentifier: "Unwind_to_Profile_Edit", sender: self)
                                    
                                    self.dismiss(animated: true) {

                                        self.performSegue(withIdentifier: "Unwind_to_Profile_Edit", sender: self)
                                    }
                                    
                                } else if JSON["success"] as? Int == 0 {
                                    
                                    let banner = NotificationBanner(title: "Error!", subtitle: (JSON["error_message"] as! String), style: .danger)
                                    banner.show()
                                    self.editProfSaveBtn.isEnabled = true
                                    self.addOverlay(added:false)
                                    
                                }
                                
                            }
                            
                            break
                            
                        case .failure(_):
                            
                            let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem updating your Profile, please try again.", style: .danger)
                            banner.show()
                            self.editProfSaveBtn.isEnabled = true
                            self.addOverlay(added:false)
                            
                            break
                            
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                    self.editProfSaveBtn.isEnabled = true
                    self.addOverlay(added:false)
                    
                }
            }
            
        } else {
            
            self.performSegue(withIdentifier: "Unwind_to_Profile_Cancel", sender: self)
            
        }
    }
    
    @IBAction func deleteProfClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Profile?", message: "Are you sure you want to Delete your Post.e account? Once you delete it, your Profile and Posts cannot be recovered!", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete Profile", style: UIAlertAction.Style.destructive, handler: { [self] action in
            
            //Delete Profile
            self.addOverlay(added:true)
            self.editProfDeleteBtn.isEnabled = false
            deleteProfile()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func addOverlay(added: Bool) {
        
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
    
    func deleteProfile() {
        
        let editProfIDString = String(editProfID)
        
        let url = instanceOfConstants.formatURL(ProfileURL)
        let parameters = ["profile_ID": editProfIDString, "command": "deleteProfile"]
        
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
                            
                            let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
                            AudioServicesPlaySystemSound(vibrate)
                            
                            self.addOverlay(added:false)
                            
                            let banner = NotificationBanner(title: self.returnTitle, subtitle: self.returnSubtitle, style: .success)
                            
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "tokenID")
                            SSKeychain.deletePassword(forService: Bundle.main.bundleIdentifier, account: "token")
                            
                            if (UserDefaults.standard.bool(forKey: "passThrough")) {
                                
                                self.performSegue(withIdentifier: "Edit_Profile_to_Login_Modally", sender: self)
                            } else {
                                
                                self.performSegue(withIdentifier: "Edit_Profile_to_Login_Unwind", sender: self)
                                
                                banner.show()
                                
                            }
                            
                        } else if JSON["success"] as? Int == 0 {
                            
                            let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
                            AudioServicesPlaySystemSound(vibrate)
                            
                            self.addOverlay(added:false)
                            let banner = NotificationBanner(title: self.returnTitle, subtitle: self.returnSubtitle, style: .danger)
                            banner.show()
                            self.editProfDeleteBtn.isEnabled = true
                            
                            
                        }
                        
                    }
                    
                    break
                    
                case .failure(_):
                    
                    let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
                    AudioServicesPlaySystemSound(vibrate)
                    
                    self.addOverlay(added:false)
                    
                    let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem deleting your Profile, please try again.", style: .danger)
                    banner.show()
                    self.editProfDeleteBtn.isEnabled = true
                    
                    
                    break
                    
                }
                
            }
        
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
    
    
}

extension UIViewController {
    func hideKeyboardWhenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
