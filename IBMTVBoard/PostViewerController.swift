//
//  PostViewerController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-05.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class PostViewerController : UIViewController {
    
    var webView : AnyObject!
    var contentURL : NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = (NSClassFromString("UIWebView") as! NSObject.Type).init()
        webView.setValue(true, forKey: "scalesPageToFit")
        webView.loadRequest(NSURLRequest(URL: contentURL))
        let view = self.webView as! UIView
        view.frame = self.view.frame
        webView.scrollView.scrollEnabled = true
        
        let inset : CGFloat = 0.0
        view.userInteractionEnabled = true
        view.frame.size.width -= inset * 2
        view.frame.size.height -= inset * 2
        view.frame.origin.x += inset
        view.frame.origin.y += inset
        
        self.view.addSubview(webView.scrollView)
        webView.scrollView.contentOffset = CGPointMake(100, 1000)

        
    }
    
}