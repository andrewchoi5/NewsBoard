//
//  VideoPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class VideoPostController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var videoLink: UITextField!
    @IBOutlet weak var videoTitle: UITextField!
    @IBOutlet weak var videoPreview: UIImageView!
    
    static let videoIDMarker = "{{VIDEO_IDENTIFIER}}"
    
    let videoPreviewAPIURLs = [
        
                                "youtube":"http://img.youtube.com/vi/\(videoIDMarker)/0.jpg"
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == videoLink) {
            loadPreview()
        }
    }


    func getAPIURLStringTemplate(let videoURLDomain: String) -> String {
        return videoPreviewAPIURLs[videoURLDomain]!
    }
    
    func getAPIURLString(let videoURLDomain: String, let videoCode: String) -> String {
        var urlTemplate = getAPIURLStringTemplate(videoURLDomain)
        urlTemplate.replaceRange(urlTemplate.rangeOfString(VideoPostController.videoIDMarker)!, with: videoCode)
        return urlTemplate

    }
    
    func getAPIURL(let urlString: String) -> NSURL {
        let url = NSURL(string: urlString)
        guard let sanitizedURL = url else {
            return NSURL()
        }
        guard let sanitizedHost = sanitizedURL.host else {
            return NSURL()
        }
        guard let sanitizedQuery = sanitizedURL.query else {
            return NSURL()
        }
        if(sanitizedHost.containsString("youtube")) {
            let videoCode = getQueryStringDictionary(sanitizedQuery)["v"]
            return NSURL(string: getAPIURLString("youtube", videoCode: videoCode!))!
        }
        return NSURL()
    }
    
    func getQueryStringDictionary(let queryString : String) -> Dictionary<String,String> {
        var queryDictionary = Dictionary<String,String>()
        let queries = queryString.componentsSeparatedByString("&")
        for query in queries {
            let queryName = query.componentsSeparatedByString("=")[0]
            let queryValue = query.componentsSeparatedByString("=")[1]
            queryDictionary[ queryName ] = queryValue
        }
        return queryDictionary
    }
    
    @IBAction func didPushPostVideoButton(sender: UIButton) {
        
        ServerInterface.postVideo(videoLink.text!, videoTitle:videoTitle.text!, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func loadPreview() {
        videoPreview.sd_setImageWithURL(getAPIURL(videoLink.text!), placeholderImage: UIImage())
    }
}