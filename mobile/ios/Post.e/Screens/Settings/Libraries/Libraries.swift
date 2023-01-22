//
//  Libraries.swift
//  Post.e
//
//  Created by Scott Grivner on 5/16/22.
//

import Foundation
import WebKit

class Libraries: UIViewController {
    
    //Objects
    @IBOutlet var libraryWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let htmlPath = Bundle.main.path(forResource: "Libraries", ofType: "html")
        let url = URL(fileURLWithPath: htmlPath!)
        let request = URLRequest(url: url)
        libraryWebView.load(request)
        

    }
}
