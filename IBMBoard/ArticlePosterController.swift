//
//  ArticlePosterController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

let greenTint = UIColor(red: 92/255.0, green: 255.0/255.0, blue: 111/255.0, alpha: 255.0/255.0)
let greyTint = UIColor(red: 63/255.0, green: 69.0/255.0, blue: 77/255.0, alpha: 255.0/255.0)


class ArticlePosterController : PosterController, UITextFieldDelegate {
    
    @IBOutlet weak var articleLink: UITextField!
    @IBOutlet weak var articleTitle: UITextField!
    @IBOutlet weak var articlePreviewBody: UITextView!
    @IBOutlet weak var articlePostButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePostButton.tintColor = greyTint
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == articleLink) {
            loadPreview()
        }
        
        // enable post button if fields are not empty 
        if (articleLink.text! != "" && articleTitle.text != "") {
            articlePostButton.enabled = true;
            articlePostButton.tintColor = greenTint
            
        } else {
            
            articlePostButton.enabled = false;
            articlePostButton.tintColor = greyTint
        }
        
    }
    
    func loadPreview() {
        articlePreviewBody.text = APIManager.getArbitraryTextArticlePreview(articleLink.text!)
        articleTitle.text = APIManager.getArbitraryTextArticleTitle()
    }
    
    @IBAction func didPushPostArticleButton() {
        selectedCardSpace.info["articleURL"] = articleLink.text!
        selectedCardSpace.info["articleTitle"] = articleTitle.text!
        selectedCardSpace.info["articlePreviewText"] = articlePreviewBody.text
        
        ServerInterface.addCard(selectedCardSpace, completion: nil)
        self.finishedCreatingPost()
        
    }

}

class IdeaPostController : PosterController, UITextFieldDelegate {
    
    @IBOutlet weak var ideaTitle: UITextField!
    @IBOutlet weak var ideaSummary: UITextView!
    @IBOutlet weak var ideaPostButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ideaPostButton.tintColor = greenTint
        
    }
    
    @IBAction func didPushPostIdeaButton(sender: UIBarButtonItem) {
        
        selectedCardSpace.info["ideaTitle"] = ideaTitle.text!
        selectedCardSpace.info["ideaPreview"] = ideaSummary.text!
        
        ServerInterface.addCard(selectedCardSpace, completion: nil)
        self.finishedCreatingPost()
        
    }
    
    
}

class RFPPostController : PosterController, UITextFieldDelegate {
    
    @IBOutlet weak var RFPTitle: UITextField!
    @IBOutlet weak var RFPSummary: UITextView!
    @IBOutlet weak var RFPPostButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RFPPostButton.tintColor = greenTint
        
    }
    
    @IBAction func didPushPostRFPButton(sender: UIBarButtonItem) {
        
        selectedCardSpace.info["RFPTitle"] = RFPTitle.text!
        selectedCardSpace.info["RFPPreview"] = RFPSummary.text!
        
        ServerInterface.addCard(selectedCardSpace, completion: nil)
        
        self.finishedCreatingPost()

    }

    
}