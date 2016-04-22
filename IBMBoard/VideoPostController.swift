//
//  VideoPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class VideoPostController : PosterController {
    
    @IBOutlet weak var videoLink: UITextField!
    @IBOutlet weak var videoTitle: UITextField!
    @IBOutlet weak var videoPreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        
        if(textField == videoLink) {
            loadPreview()
            
        }
        
    }
    
    override func prepareToUpdateWithCardContent() {
        videoLink.text = card.info["videoURL"] as? String
        videoTitle.text = card.info["videoTitle"] as? String
        videoPreview.sd_setImageWithURL(VideoAPIManager.getAPIURL(videoLink.text!), placeholderImage: UIImage())
        
    }
    
    override func isReadyForPosting() -> Bool {
        return (videoLink.text! != "" && videoTitle.text != "")
        
    }
    
    override func didPushPostButton(sender: UIBarButtonItem) {
        
        card.videoURL = NSURL(string: videoLink.text!)
        card.videoTitle = videoTitle.text
        
        self.finish()
    }
    
    func loadPreview() {
        videoPreview.sd_setImageWithURL(VideoAPIManager.getAPIURL(videoLink.text!), placeholderImage: UIImage())
        
        APIManager.getArbitraryVideoTitle(videoLink.text!, maxLength: 1000) { (title) in
            self.videoTitle.delegate!.textFieldDidBeginEditing!(self.videoTitle)
            self.videoTitle.text = title
            self.videoTitle.delegate!.textFieldDidEndEditing!(self.videoTitle)
            
        }
        
        if videoLink.text == "" {
            Dialog.showError("Invalid video URL", viewController: self)
            
        }
        
    }

}