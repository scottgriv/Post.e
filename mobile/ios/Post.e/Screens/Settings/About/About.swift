//
//  About.swift
//  Post.e
//
//  Created by Scott Grivner on 6/27/22.
//

import Foundation
import MessageUI
import UIKit

class About: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var aboutVersion: UILabel!
    @IBOutlet var aboutDeveloper: UILabel!
    @IBOutlet var aboutContact: UIButton!
    @IBOutlet var aboutWebsite: UIButton!
    @IBOutlet var aboutCopyright: UILabel!
    
    let instanceOfAppInfo = AppInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutVersion.text = "\(instanceOfAppInfo.appName) v\(instanceOfAppInfo.version)"
        aboutDeveloper.text = instanceOfAppInfo.aboutDeveloper
        aboutContact.setTitle(instanceOfAppInfo.aboutContactEmail, for: .normal)
        aboutWebsite.setTitle(instanceOfAppInfo.aboutContactWebsite, for: .normal)
        aboutCopyright.text = "© \(instanceOfAppInfo.currentYear) \(instanceOfAppInfo.aboutDeveloper). \n All Rights Reserved."
    }
    
    @IBAction func launchEmail(sender: AnyObject) {
        
        let emailTitle = "Post.e Feedback"
        let messageBody = "Questions or Comments around Post.e?"
        let toRecipents = [instanceOfAppInfo.aboutContactEmail]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    @IBAction func launchWebsite(_ sender: Any) {
        
        if let url = URL(string: "http://\(instanceOfAppInfo.aboutContactWebsite)") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
}
