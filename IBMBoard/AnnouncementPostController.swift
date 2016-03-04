//
//  AnnoucementPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-25.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class AnnouncementPostController : PosterController {
    
    @IBOutlet weak var announcementText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func didPushPostButton(sender: UIButton) {
        
        selectedCardSpace.info["announcementText"] = announcementText.text!
        
        ServerInterface.postCard(selectedCardSpace, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
}