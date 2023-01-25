//
//  Post.swift
//  Post.e
//
//  Created by Scott Grivner on 12/31/21.
//

import UIKit
import Foundation
import YPImagePicker
import QuickLook
import Alamofire
import NotificationBannerSwift
import MobileCoreServices
import UniformTypeIdentifiers

class PostAttachmentCell: UITableViewCell {
    
    @IBOutlet var postCellImg: UIImageView?
    @IBOutlet var postCellFileNameBtn: UIButton!
    @IBOutlet var postCellRemoveBtn: UIButton?
    @IBOutlet var postCellCreationDate: UILabel!
    @IBOutlet var postCellFileSize: UILabel!
    
}

class Post: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource, UIDocumentPickerDelegate {
    
    
    //Unit Test Function
    public func sum(a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if (self.postTxtVw.text != NSLocalizedString("POST_MESSAGE", comment: "")) {
            
            setPostTextColors()
            
        }
    }
    
    var previewItem: URL!
    
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
    
    //Objects
    @IBOutlet var postTable: UITableView!
    @IBOutlet var postBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var photoBtn: UIButton!
    @IBOutlet var attachmentBtn: UIButton!
    @IBOutlet var postTxtVw: UITextView!
    @IBOutlet var postVw: UIView!
    
    //Variables
    @objc var profileID: Int = 0
    @objc var postID: Int = 0
    @objc var previousVC:String = ""
    
    var postAttachFile: Data!
    var postAttachFilePath: URL!
    var postAttachFileName: String!
    var postAttachFileExtension: String!
    var postAttachFileSize: String!
    var postAttachCreationDate: String!
    var postAttachModificationDate: String!
    var photoPickerSelected : Bool = false
    var postAttachArray = [Any]()
    var postAttachDataArray = [Any]()
    var myDataManager = DataManager()
    var instanceOfConstants = Constants()
    
    let cellReuseIdentifier = "postAttachmentCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.postTable.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        self.postTable.contentInset = UIEdgeInsets(top: -48, left: 0, bottom: 0, right: 0)
        
        postTable.delegate = self
        postTable.dataSource = self
        
        print ("Previous VC: \(previousVC).")
        
        self.postTxtVw.delegate = self
        self.postTxtVw.text = NSLocalizedString("POST_MESSAGE", comment: "")
        self.postTxtVw.textColor = .lightGray
        
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        
        // 2. add the gesture recognizer to a view
        self.postTable.addGestureRecognizer(tapGesture)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.postTxtVw.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0;
        
    }
    
    //Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.postAttachArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:cellReuseIdentifier, for: indexPath) as! PostAttachmentCell
        
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        
        let myPost = self.postAttachArray[indexPath.row] as! DataManager
        
        cell.postCellFileNameBtn.setTitle(myPost.postAttachmentFileName, for: .normal)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: myPost.postAttachmentCreationDate)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date!)
        print("EXACT_DATE : \(dateString)")
        
        cell.postCellCreationDate!.text = dateString
        cell.postCellFileSize!.text = myPost.postAttachmentFileSize
        
        cell.postCellRemoveBtn!.tag = indexPath.row
        cell.postCellFileNameBtn!.tag = indexPath.row
        
        cell.postCellImg!.image = myPost.postAttachmentThumbnail
        
        return cell
    }
    
    //Method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func addBadge(badgeCount: String) {
        
        let badge = UILabel(frame: CGRect(x: 30, y: 1, width: 20, height: 20))
        badge.layer.borderColor = UIColor.clear.cgColor
        badge.layer.borderWidth = 2
        badge.layer.cornerRadius = badge.bounds.size.height / 2
        badge.textAlignment = .center
        badge.layer.masksToBounds = true
        badge.textColor = .white
        badge.font = badge.font.withSize(12)
        badge.backgroundColor = .red
        badge.text = badgeCount
        self.attachmentBtn.addSubview(badge)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 250    // Future: Pull in Limit from Database (Current column size is 250)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Did Begin Editing")
        
        if (self.postTxtVw.text == NSLocalizedString("POST_MESSAGE", comment: "")) {
            
            textView.text = ""
            setPostTextColors()
            
        }
        
    }
    
    func setPostTextColors() {
        
        print("Set Post Text Colors")
        
        switch UIScreen.main.traitCollection.userInterfaceStyle {
        case .dark:
            self.postTxtVw.textColor = .white
        case .light:
            self.postTxtVw.textColor = .black
        case .unspecified:
            self.postTxtVw.textColor = .black
        @unknown default:
            self.postTxtVw.textColor = .black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Did End Editing")
        
    }
    
    //This method is called when a tap is recognized
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        print("Background Tapped")
        
        cancelPost()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if photoPickerSelected {
            photoPickerSelected = false
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: UIView.AnimationOptions.transitionCrossDissolve,
                           animations: {
                
                self.postTable.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                
            }, completion: { (finished) -> Void in
                
            })
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !photoPickerSelected {
            
            UIView.animate(withDuration: 0.1,
                           delay: 0.0,
                           options: UIView.AnimationOptions.transitionCrossDissolve,
                           animations: {
            }, completion: { (finished) -> Void in
                self.postTable.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            })
            
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
    
    func cancelPost() {
        
        if (self.postAttachArray.count != 0) {
            // create the alert
            let alert = UIAlertController(title: "Wait...", message: "You will have to recreate your Post and add your attachments again if you exit!", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Exit", style: UIAlertAction.Style.destructive, handler: { [self] action in
                
                // do something like...
                performSegue(withIdentifier: "Unwind_to_\(self.previousVC)_Cancel", sender: self)
                clearTmpDir()
                
            }))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else if (self.postTxtVw.text ?? "" != NSLocalizedString("POST_MESSAGE", comment: "")) {
            
            print("Text View Value:", self.postTxtVw.text ?? "")
            
            let alert = UIAlertController(title: "Wait...", message: "You will have to recreate your Post and add your attachments again if you exit!", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Exit", style: UIAlertAction.Style.destructive, handler: { [self] action in
                
                // do something like...
                performSegue(withIdentifier: "Unwind_to_\(self.previousVC)_Cancel", sender: self)
                
            }))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: "Unwind_to_\(previousVC)_Cancel", sender: self)
            clearTmpDir()
            
        }
    }
    
    func submitPost() {
        
        performSegue(withIdentifier: "Unwind_to_\(previousVC)_Submit", sender: self)
        clearTmpDir()
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        print("Cancel Clicked!")
        cancelPost()
        
    }
    
    @IBAction func fileAttachmentClicked(_ sender: UIButton) {
        
        let myPost = self.postAttachArray[sender.tag] as! DataManager
        
        downloadFile(fileUrl: myPost.postAttachmentFilePath)
        
    }
    
    
    @IBAction func removeAttachmentClicked(_ sender: UIButton) {
        
        print("Sender.tag: \(sender.tag)")
        let hitPoint = sender.convert(CGPoint.zero, to: postTable)
        if let indexPath = postTable.indexPathForRow(at: hitPoint) {
            self.postTable.beginUpdates()
            self.postAttachArray.remove(at: indexPath.row)
            self.postTable.deleteRows(at:[IndexPath(row:indexPath.row,section:0)],with:.bottom)
            self.postTable.endUpdates()
            
        }
        
    }
    
    @IBAction func photoClicked(_ sender: Any) {
        
        let maxAttachments: Int! = 9
        
        if (self.postAttachArray.count >= maxAttachments) {
            
            let banner = NotificationBanner(title: "Warning!", subtitle: "You've reached the maximum number of attachments for this Post (9). Please delete an attachment to add more.", style: .warning)
            banner.show()
            
        } else {
            
            photoPickerSelected = true
            
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = maxAttachments - self.postAttachArray.count
            config.shouldSaveNewPicturesToAlbum = true
            config.screens = [.library, .video, .photo]
            config.library.mediaType = .photoAndVideo
            //config.video.compression = AVAssetExportPresetHighestQuality
            //config.video.fileType = .mp4
            config.video.recordingTimeLimit = 60.0
            config.video.libraryTimeLimit = 200.0
            config.video.minimumTimeLimit = 3.0
            config.video.trimmerMaxDuration = 60.0
            config.video.trimmerMinDuration = 3.0
            config.usesFrontCamera = true
            config.showsPhotoFilters = true
            config.showsVideoTrimmer = true
            //let page = PageViewController()
            
            let picker = YPImagePicker(configuration: config)
            
            picker.didFinishPicking { [unowned picker] items, _ in
                for item in items {
                    switch item {
                    case .photo(let photo):
                        
                        print(photo.fromCamera) // Image source (camera or library)
                        print(photo.image) // Final image selected by the user
                        print(photo.originalImage) // original image selected by the user, unfiltered
                        print(photo.modifiedImage as Any) // Transformed image, can be nil
                        print(photo.exifMeta ?? "") // Print exit meta data of original image.
                        
                        self.postAttachFileName = "\(UUID().uuidString)"
                        
                        var imgData : Data!
                        
                        if photo.modifiedImage != nil {
                            imgData = photo.modifiedImage?.jpegData(compressionQuality: 1.0)
                        } else {
                            imgData = photo.originalImage.jpegData(compressionQuality: 1.0)
                        }
                        
                        debugPrint("Size of Image: \(imgData!.count) bytes")
                        self.postAttachFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(self.postAttachFileName)
                        try? imgData!.write(to: self.postAttachFilePath)
                        
                        print("Attachment File Path:")
                        print(self.postAttachFilePath!); //URL
                        
                        self.postAttachFile = imgData
                        
                        let imageData:NSData = NSData(contentsOf: self.postAttachFilePath)!
                        let image = UIImage(data: imageData as Data)
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"//"eeee' = 'D"
                        
                        let myPostAttach = type(of: self.myDataManager).init(postAttachmentType: "Photo", andPostAttachmentFile: self.postAttachFile, andPostAttachmentFilePath: self.postAttachFilePath, andPostAttachmentFileName: self.postAttachFileName, andPostAttachmentFileExtension: "jpg", andPostAttachmentFileSize: (self.humanReadableByteCount(bytes: imgData!.count)), andPostAttachmentCreationDate: formatter.string(from: Date()), andPostAttachmentModificationDate: "", andPostAttachmentThumbnail: image!)
                        
                        self.postAttachArray.append(myPostAttach)
                        self.postTable.reloadData()
                        
                    case .video(let video):
                        
                        print(video.fromCamera)
                        print(video.thumbnail)
                        print(video.url)
                        
                        self.postAttachFileName = "\(UUID().uuidString)"
                        self.postAttachFile = try? Data(contentsOf: video.url)
                        
                        print("Attachment File Path:")
                        print(video.url); //URL
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zz"//"eeee' = 'D"
                        
                        let myPostAttach = type(of: self.myDataManager).init(postAttachmentType: "Video", andPostAttachmentFile: self.postAttachFile, andPostAttachmentFilePath: video.url, andPostAttachmentFileName: self.postAttachFileName, andPostAttachmentFileExtension: "mp4", andPostAttachmentFileSize: (self.humanReadableByteCount(bytes: self.postAttachFile!.count)), andPostAttachmentCreationDate: formatter.string(from: Date()), andPostAttachmentModificationDate: "", andPostAttachmentThumbnail:video.thumbnail)
                        
                        self.postAttachArray.append(myPostAttach)
                        self.postTable.reloadData()
                        
                    }
                }
                
                picker.dismiss(animated: true, completion: nil)
                
            }
            present(picker, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func attachmentClicked(_ sender: Any) {
        print("Attachment Clicked!")
        
        //Futue: Link the Param_Code : MAX_ATTACHMENTS to the Default Values to change the default max amount of attachments.
        //Current Max: 9.
        let maxAttachments: Int! = 9
        
        if (self.postAttachArray.count >= maxAttachments) {
            
            let banner = NotificationBanner(title: "Warning!", subtitle: "You've reached the maximum number of attachments for this Post (9). Please delete an attachment to add more.", style: .warning)
            banner.show()
            
        } else {
            
            callDocumentPicker()
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        return documentsDirectory
        
    }
    
    func callDocumentPicker () {
        
        // Create a document picker for directories.
        // ***Future***: Retrieve Extensions from Database:
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
            UTType.jpeg,
            .png,
            .mp3,
            .quickTimeMovie,
            .mpeg,
            .mpeg2Video,
            .mpeg2TransportStream,
            .mpeg4Movie,
            .mpeg4Audio,
            .appleProtectedMPEG4Audio,
            .avi,
            .aiff,
            .wav,
            .midi,
            .tiff,
            .gif,
            .icns,
            .text,
            .rtf,
            .bmp,
            .pdf,
            .xml,
            .svg,
            .zip,
            .mp3
        ])
        
        documentPicker.delegate = self
        
        // Sample Directory
        if (UserDefaults.standard.bool(forKey: "useSampleDirectory")) {
            
            let sampleDirectory = getDocumentsDirectory().appendingPathComponent("Post.e Sample Files", isDirectory: true)
            print("Document Path: \(sampleDirectory)")
            
            documentPicker.directoryURL = sampleDirectory
            
        }
        
        /*
         guard sampleDirectory.startAccessingSecurityScopedResource() else {
         return
         }
         
         do {
         
         sampleDirectory.stopAccessingSecurityScopedResource()
         }
         */
        
        documentPicker.allowsMultipleSelection = false
        
        // Over Full Screen
        documentPicker.modalPresentationStyle = .overFullScreen
        
        // Present the document picker.
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let maxFileSize: Int! = 1073741824
        
        do {
            
            for url in urls {
                
                guard url.startAccessingSecurityScopedResource() else {
                    return
                }
                
                do {
                    
                    url.stopAccessingSecurityScopedResource()
                }
                
                let resources = try url.resourceValues(forKeys:[.fileSizeKey, .creationDateKey, .contentModificationDateKey])
                
                let fileName = URL(fileURLWithPath: url.absoluteString).deletingPathExtension().lastPathComponent
                
                print("Attachment Display Name: \(fileName)")
                print("Attachment File Extension: \(url.pathExtension)")
                print("Attachment File Path: \(url)")
                print("Attachment File:")
                print("Attachment Creation Date: \(resources.creationDate!)")
                print("Attachment Modification Date: \(resources.contentModificationDate!)")
                print("Attachment File Size: \(humanReadableByteCount(bytes: resources.fileSize!))")
                
                //Check if the file is already added to the array.
                if (checkRecords(fileName: url.lastPathComponent)) {
                    
                    let banner = NotificationBanner(title: "Warning!", subtitle: "You've already added this file to your Post attachments, please select a different file.", style: .warning)
                    banner.show()
                    
                    //***Future***: Link the Param_Code : MAX_FILE_SIZE to the Default Values to change the default max file size.
                    //Current Max: 1 GB (in bytes).
                } else if (resources.fileSize! > maxFileSize) {
                    
                    let banner = NotificationBanner(title: "Warning!", subtitle: "The file you selected is too large to attach to this Post. The maximum file size is (1 GB). Please select a smaller file.", style: .warning)
                    banner.show()
                    
                } else {
                    
                    postAttachFileName = fileName
                    postAttachFileExtension = url.pathExtension
                    postAttachFilePath = url
                    postAttachFile = try? Data(contentsOf: url)
                    postAttachCreationDate = String(describing:resources.creationDate!)
                    postAttachModificationDate = String(describing:resources.contentModificationDate!)
                    postAttachFileSize = humanReadableByteCount(bytes: resources.fileSize!)
                    
                    print(postAttachCreationDate ?? "")
                    print(postAttachModificationDate ?? "")
                    print(postAttachFileSize ?? "")
                    
                    let imageSuffix = self.postAttachFileExtension
                    let imageName = "Ext-" + imageSuffix!
                    let image : UIImage!
                    
                    if UIImage(named: imageName) != nil {
                        image = UIImage(named:imageName)
                    } else {
                        image = UIImage(named:"Ext-misc")
                    }
                    
                    let myPostAttach = type(of: self.myDataManager).init(postAttachmentType: "File", andPostAttachmentFile: postAttachFile, andPostAttachmentFilePath: postAttachFilePath, andPostAttachmentFileName: postAttachFileName, andPostAttachmentFileExtension: postAttachFileExtension, andPostAttachmentFileSize: postAttachFileSize, andPostAttachmentCreationDate: postAttachCreationDate, andPostAttachmentModificationDate: postAttachModificationDate, andPostAttachmentThumbnail: image)
                    
                    self.postAttachArray.append(myPostAttach)
                    self.postTable.reloadData()
                    
                }
                
            }
            
        } catch {
            print("Error: \(error)")
        }
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    func checkRecords(fileName: String) -> Bool {
        
        var recordFound = false
        
        for i in 0 ..< postAttachArray.count {
            
            let myPost = self.postAttachArray[i] as! DataManager
            
            if myPost.postAttachmentFileName == fileName {
                
                recordFound = true;
            }
            
        }
        
        if (recordFound) {
            
            return true;
            
        } else {
            
            return false;
        }
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
    
    func humanReadableByteCount(bytes: Int) -> String {
        if (bytes < 1000) { return "\(bytes) B" }
        let exp = Int(log2(Double(bytes)) / log2(1000.0))
        let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
        let number = Double(bytes) / pow(1000, Double(exp))
        if exp <= 1 || number >= 100 {
            return String(format: "%.0f %@", number, unit)
        } else {
            return String(format: "%.1f %@", number, unit)
                .replacingOccurrences(of: ".0", with: "")
        }
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    @IBAction func postClicked(_ sender: Any) {
        print("Post Clicked!")
        
        if (self.postTxtVw.text == NSLocalizedString("POST_MESSAGE", comment: "") || self.postTxtVw.text == "") {
            
            let banner = NotificationBanner(title: "Warning!", subtitle: "Your Post is missing! Please add some content in order to Post.", style: .warning)
            banner.show()
            
        } else {
            
            self.postBtn.isEnabled = false
            
            self.addOverlay(added:true)
            
            let url = instanceOfConstants.formatURL(PostURL)
            let textView : String = self.postTxtVw.text
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                var postAttachDict = [String: Any]()
                for i in 0 ..< self.postAttachArray.count {
                    
                    let myPost = self.postAttachArray[i] as! DataManager
                    
                    print(String(i))
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                    let postCreateDate = dateFormatter.date(from: myPost.postAttachmentCreationDate)
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let createDateString = dateFormatter.string(from: postCreateDate!)
                    
                    print("createDateString: \(createDateString)")
                    
                    postAttachDict[String(i)] = ["post_attachment_file_name" : myPost.postAttachmentFileName, "post_attachment_file_extension" : myPost.postAttachmentFileExtension, "post_attachment_file_size" : myPost.postAttachmentFileSize, "post_attachment_creation_date" : createDateString]
                    
                    if (myPost.postAttachmentModificationDate != "") {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                        let postModDate = dateFormatter.date(from: myPost.postAttachmentModificationDate)
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let modDateString = dateFormatter.string(from: postModDate!)
                        
                        print("postModDate: \(String(describing: postModDate))")
                        
                        postAttachDict[String(i)] = ["post_attachment_file_name" : myPost.postAttachmentFileName, "post_attachment_file_extension" : myPost.postAttachmentFileExtension, "post_attachment_file_size" : myPost.postAttachmentFileSize, "post_attachment_creation_date" : createDateString, "post_attachment_modification_date" : modDateString]
                        
                    }
                    
                    
                    
                    
                    
                    multipartFormData.append(myPost.postAttachmentFile, withName: "\(String(i))", fileName: myPost.postAttachmentFileName, mimeType: self.mimeTypeForPath(path: myPost.postAttachmentFileName))
                    
                }
                
                
                let jsonData = try! JSONSerialization.data(withJSONObject: postAttachDict)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                
                let parameters: Parameters = ["profile_ID": self.profileID, "post_ID": self.postID, "post": textView, "attachments": jsonString ?? "", "type": self.previousVC, "command": "createPost"]
                
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
                                    
                                    self.addOverlay(added:false)
                                    
                                    let banner = NotificationBanner(title: "Success!", subtitle: "Your Post has been submitted!", style: .success)
                                    banner.show()
                                    
                                    self.submitPost()
                                    
                                } else if JSON["success"] as? Int == 0 {
                                    
                                    self.addOverlay(added:false)
                                    
                                    let banner = NotificationBanner(title: "Error!", subtitle: String(describing: JSON["error_message"]), style: .danger)
                                    banner.show()
                                    
                                    self.postBtn.isEnabled = true
                                    
                                    
                                }
                                
                            }
                            
                            break
                            
                        case .failure(_):
                            
                            self.addOverlay(added:false)
                            
                            let banner = NotificationBanner(title: "Error!", subtitle: "There was a problem submitting your Post, please try again.", style: .danger)
                            banner.show()
                            
                            self.postBtn.isEnabled = true
                            
                            break
                            
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                }
            }
            
        }
    }
    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    
}
