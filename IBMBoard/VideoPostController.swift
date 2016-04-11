//
//  VideoPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class VideoPostController : PosterController, UITextFieldDelegate {
    
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
    
    @IBAction func didPushPostVideoButton(sender: UIButton) {
        
        selectedCardSpace.info["videoURL"] = videoLink.text!
        selectedCardSpace.info["videoTitle"] = videoTitle.text!
        
        ServerInterface.addCard(selectedCardSpace, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func loadPreview() {
        videoPreview.sd_setImageWithURL(VideoAPIManager.getAPIURL(videoLink.text!), placeholderImage: UIImage())
        videoTitle.text = APIManager.getArbitraryVideoTitle(videoLink.text!, maxLength: 1000)
    }
}