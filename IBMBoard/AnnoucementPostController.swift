//
//  AnnoucementPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-25.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class AnnoucmentPostController : UIViewController {
    
    @IBOutlet weak var annocunmentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func didPushPostButton(sender: UIButton) {
        
        ServerInterface.postAnnouncement(annocunmentText.text!, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
}