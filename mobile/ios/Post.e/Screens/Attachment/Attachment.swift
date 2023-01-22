//
//  Attachment.swift
//  Post.e
//
//  Created by Scott Grivner on 4/5/22.
//

import UIKit
import Foundation
import YPImagePicker
import QuickLook
import Alamofire
import NotificationBannerSwift
import MobileCoreServices

class AttachmentCell: UITableViewCell {
    
    @IBOutlet var attachCellImg: UIImageView?
    @IBOutlet var attachCellFileNameBtn: UIButton!
    @IBOutlet var attachCellCreationDate: UILabel!
    @IBOutlet var attachCellFileSize: UILabel!
    @IBOutlet var attachCellDownloadFile: UIButton!
    @IBOutlet var attachCellLoadingAI: UIActivityIndicatorView!
    
}

class Attachment: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource {
    
    //Objects
    @IBOutlet var attachmentTable: UITableView!
    
    //Variables
    @objc var profileID: Int = 0
    @objc var postID: Int = 0
    @objc var attachArray = [Any]()
    @objc var previousVC:String = ""
    
    //Variable
    var postAttachFile: Data!
    var postAttachFilePath: URL!
    var postAttachFileName: String!
    var postAttachFileExtension: String!
    var postAttachFileSize: String!
    var postAttachCreationDate: String!
    var postAttachModificationDate: String!
    var photoPickerSelected : Bool = false
    var previewItem: URL!
    var attachDataArray = [Any]()
    var myDataManager = DataManager()
    var instanceOfConstants = Constants()
    
    let cellReuseIdentifier = "attachmentCell"
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem as QLPreviewItem
        
    }
    
    func downloadFile(fileUrl: URL) {
        
        let previewController = QLPreviewController()
        self.previewItem = fileUrl
        previewController.dataSource = self
        present(previewController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachmentTable.delegate = self
        attachmentTable.dataSource = self
        
        print("Attachment Array: \(attachArray).")
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0;
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.attachArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:cellReuseIdentifier, for: indexPath) as! AttachmentCell
        cell.selectionStyle = .none
        
        let myAttachment = self.attachArray[indexPath.row] as! DataManager
        
        cell.attachCellFileNameBtn.setTitle(myAttachment.attachmentsFileName, for: .normal)
        
        cell.attachCellLoadingAI.startAnimating()
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save local temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set local to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: myAttachment.attachmentsCreated)!
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = tempLocale // reset the local
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        
        cell.attachCellCreationDate!.text = dateString
        
        cell.attachCellFileSize!.text = myAttachment.attachmentsFileSize
        
        cell.attachCellFileNameBtn!.tag = indexPath.row
        cell.attachCellFileNameBtn.addTarget(self, action: #selector(fileAttachmentClicked), for: .touchUpInside)
        
        Alamofire.request(myAttachment.attachmentsFilePath, method: .get)
            .validate()
            .downloadProgress { (progress) in
                
            }
            .responseData(completionHandler: { (responseData) in
                
                cell.attachCellImg!.image = UIImage(data: responseData.data!)
                print("File Extension: \(myAttachment.attachmentsFileExtension)")
                
                if cell.attachCellImg!.image == nil {
                    
                    let imageSuffix = myAttachment.attachmentsFileExtension
                    let imageName = "Ext-" + imageSuffix
                    let image : UIImage!
                    
                    if UIImage(named: imageName) != nil {
                        image = UIImage(named:imageName)
                    } else {
                        image = UIImage(named:"Ext-misc")
                    }
                    
                    cell.attachCellImg!.image = image
                    
                }
                
                cell.attachCellLoadingAI.stopAnimating()
                cell.attachCellLoadingAI.isHidden = true
                
                DispatchQueue.main.async {
                    // Refresh you views
                }
            })
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // No need for semicolon
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) // No need for semicolon
        
    }
    
    @IBAction func fileAttachmentClicked(_ sender: UIButton) {
        
        // 1
        let myAttachment = self.attachArray[sender.tag] as! DataManager
        
        let itemURL = URL(string: myAttachment.attachmentsFilePath)!
        var fileURL: URL?
        
        let quickLookController = QLPreviewController()
        quickLookController.dataSource = self
        
        do {
            // Download the pdf and get it as data
            // This should probably be done in the background so we don't
            // freeze the app. Done inline here for simplicity
            let data = try Data(contentsOf: itemURL)
            
            let fileName = myAttachment.attachmentsFileName + "." + myAttachment.attachmentsFileExtension
            // Give the file a name and append it to the file path
            fileURL = FileManager().temporaryDirectory.appendingPathComponent(fileName)
            if let fileUrl = fileURL {
                // Write the pdf to disk in the temp directory
                try data.write(to: fileUrl)
            }
            
            // Make sure the file can be opened and then present the pdf
            let previewController = QLPreviewController()
            self.previewItem = fileURL
            previewController.dataSource = self
            present(previewController, animated: true)
            
            
        } catch {
            // cant find the url resource
        }
        
    }
    
}
