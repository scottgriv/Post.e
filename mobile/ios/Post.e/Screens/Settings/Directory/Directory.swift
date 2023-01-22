//
//  Directory.swift
//  Post.e
//
//  Created by Scott Grivner on 5/15/22.
//

import Foundation

class Directory: UIViewController {
    
    //Variables
    var instanceOfConstants = Constants()
    var returnTitle: String!
    var returnSubtitle: String!
    var pickedFolderURL: URL!
    var directoryPath: String!
    @IBOutlet var sampleSwitch: UISwitch!
    @IBOutlet var directoryPathTxtView: UITextView!
    var switchBool : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        directoryPathTxtView.isEditable = false
        
        setDirectory()
        
    }
    
    @IBAction func sampleSwitchClicked(_ sender: Any) {
        
        if sampleSwitch.isOn == true {
            
            switchBool = true

        } else {
            
            switchBool = false

        }
        
        UserDefaults.standard.set(switchBool, forKey: "useSampleDirectory")
        setDirectory()

    }
    
    func setDirectory() {
        
        if (UserDefaults.standard.bool(forKey: "useSampleDirectory")) {
            directoryPathTxtView.text = getDocumentsDirectory().appendingPathComponent("Post.e Sample Files", isDirectory: true).absoluteString
            sampleSwitch.isOn = true
            
        } else {
            directoryPathTxtView.text = getDocumentsDirectory().absoluteString
            sampleSwitch.isOn = false

        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
