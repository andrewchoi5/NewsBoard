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
    @IBOutlet weak var videoPostButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTitleColorOfBarButtonItem(videoPostButton)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == videoLink) {
            loadPreview()
        }
        
        // enable post button if fields are not empty
        if (videoLink.text! != "" && videoTitle.text != "") {
            videoPostButton.enabled = true;
            videoPostButton.tintColor = UIColor.mainAccentGreen()
            
        } else {
            videoPostButton.enabled = false;
            videoPostButton.tintColor = UIColor.secondaryTileColor()
            
        }
        
    }
    
    @IBAction func didPushPostVideoButton(sender: UIBarButtonItem) {
        
        selectedCardSpace.info["videoURL"] = videoLink.text!
        selectedCardSpace.info["videoTitle"] = videoTitle.text!
        
        self.startedCreatingPost()
        ServerInterface.addCard(selectedCardSpace) {
            self.finishedCreatingPost()
            
        }
    }
    
    func loadPreview() {
        videoPreview.sd_setImageWithURL(VideoAPIManager.getAPIURL(videoLink.text!), placeholderImage: UIImage())
        videoTitle.text = APIManager.getArbitraryVideoTitle(videoLink.text!, maxLength: 1000)
    }
    
    override func enableBarButtonItem() {
        videoPostButton.enabled = true
        
    }
}