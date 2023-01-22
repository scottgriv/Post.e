//
//  Language.swift
//  Post.e
//
//  Created by Scott Grivner on 7/21/22.
//

import Foundation
import Alamofire
import NotificationBannerSwift

struct Languages: Decodable {
    
    struct Header: Decodable {
        
        let current_language_code: String?
        let current_language_name: String?
        
        enum CodingKeys: String, CodingKey {
            case current_language_code = "current_language_code"
            case current_language_name = "current_language_name"
        }
    }
    
    struct Details: Decodable {
        
        let language_code: String?
        let language_name: String?
        
        enum CodingKeys: String, CodingKey {
            case language_code = "language_code"
            case language_name = "language_name"
        }
    }
    
    var header = [Header]()
    var details = [Details]()
    
    enum CodingKeys: String, CodingKey {
        case header = "header"
        case details = "details"
    }
}

class Language: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Objects
    @IBOutlet var languagePicker: UIPickerView!
    @IBOutlet var currentLanguageLbl: UILabel!
    @IBOutlet var languageInstructionsLbl: UILabel!
    @IBOutlet var openSettingsBtn: UIButton!
    
    //Variables
    var langArray: [String] = []
    var currentLangCode: String!
    var currentLangName: String!
    var instanceOfConstants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openSettingsBtn.layer.cornerRadius = 10

        languagePicker.dataSource = self
        languagePicker.delegate = self
        
        if let code = Locale.current.languageCode {
            print("Locale.current.languageCode ======== \(code)")
            currentLangCode = code
        } else {
            
            print("Language Not Available")
            currentLangCode = "na"
        }
        
        setPostTextColors()
        retrieveLanguages()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setPostTextColors()

    }
    
    func setPostTextColors() {
                
        print("Set Post Text Colors")

        switch UIScreen.main.traitCollection.userInterfaceStyle {
            
          case .dark: // put your dark mode code here
            //is dark
            setAppearance(color:255)
            
          case .light:
            //is light
            setAppearance(color:200)
            
          case .unspecified:
            //is light
            setAppearance(color:0)

        @unknown default:
            //is light
            setAppearance(color:0)

        }
        
    }
    
    func setAppearance(color: CGFloat) {
        
        //is light
        self.currentLanguageLbl.layer.borderColor = UIColor(red:color/255, green:color/255, blue:color/255, alpha: 1).cgColor
        
        self.languagePicker.layer.borderColor = UIColor(red:color/255, green:color/255, blue:color/255, alpha: 1).cgColor
        
        self.languageInstructionsLbl.layer.borderColor = UIColor(red:color/255, green:color/255, blue:color/255, alpha: 1).cgColor
        
    }
    
    func retrieveLanguages() {
        
        let url = instanceOfConstants.formatURL(InteractionURL)
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept") 
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "current_language_code" : currentLangCode ?? "na",
            "command": "Languages"
        ]
        request.httpBody = parameters.percentEncoded()
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { print(error); return }
            do {
                
                let languages = try JSONDecoder().decode(Languages.self, from: data!)
                
                print("Current Language Code:", languages.header.first?.current_language_code! as Any)
                print("Current Language Name:", languages.header.first?.current_language_name! as Any)
                
                for (index, value) in languages.details.enumerated() {
                    
                    print("\(index): \(value)")
                    
                    self.langArray.append(value.language_name ?? "")
                
                }
                
                DispatchQueue.main.async {
                    
                    self.currentLanguageLbl.text = languages.header.first?.current_language_name!
                    self.languagePicker.reloadAllComponents()
                    
                }
                
            } catch let jsonErr {
                print ("Error serializing json: ", jsonErr)
            }
        }
        
        dataTask.resume()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return langArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return langArray[row]
        
    }
    
    @IBAction func openSettingsBtnClicked(_ sender: Any) {
    
        let alertController = UIAlertController (title: "Change Language", message: "Go to Settings?", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
        
    }
    
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
