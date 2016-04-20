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
    
    func textFieldDidEndEditing(textField: UITextField) {        
        if(textField == videoLink) {
            loadPreview()
            
        }
        
    }
    
    override func isReadyForPosting() -> Bool {
        return videoLink.text! != "" && videoTitle.text != ""
        
    }
    
    override func didPushPostButton(sender: UIBarButtonItem) {
        
        selectedCardSpace.videoURL = NSURL(string: videoLink.text!)
        selectedCardSpace.videoTitle = videoTitle.text
        
        self.startedCreatingPost()
        ServerInterface.addCard(selectedCardSpace) {
            self.finishedCreatingPost()
            
        }
    }
    
    func loadPreview() {
        videoPreview.sd_setImageWithURL(VideoAPIManager.getAPIURL(videoLink.text!), placeholderImage: UIImage())
        videoTitle.text = APIManager.getArbitraryVideoTitle(videoLink.text!, maxLength: 1000)
    }

}