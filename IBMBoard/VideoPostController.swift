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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == videoLink) {
            loadPreview()
        }
    }

    func loadPreview() {
        videoPreview.sd_setImageWithURLString(videoLink.text!, placeholderImage: UIImage())
    }
}