//
//  ArticlePosterController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class ArticlePosterController : PosterController {
    
    @IBOutlet weak var articleLink: UITextField!
    @IBOutlet weak var articleTitle: UITextField!
    @IBOutlet weak var articlePreviewBody: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == articleLink) {
            loadPreview()
        }
        
    }
    
    override func isReadyForPosting() -> Bool {
        return articlePreviewBody.text! != "" && articleTitle.text != ""
        
    }
    
    func loadPreview() {
        articlePreviewBody.text = APIManager.getArbitraryTextArticlePreview(articleLink.text!)
        articleTitle.text = APIManager.getArbitraryTextArticleTitle()
    }
    
    override func didPushPostButton(button : UIBarButtonItem) {
        selectedCardSpace.info["articleURL"] = articleLink.text!
        selectedCardSpace.info["articleTitle"] = articleTitle.text!
        selectedCardSpace.info["articlePreviewText"] = articlePreviewBody.text
        
        self.startedCreatingPost()
        ServerInterface.addCard(selectedCardSpace) {
            self.finishedCreatingPost()
            
        }
        
    }

}

class IdeaPostController : PosterController {
    
    @IBOutlet weak var ideaTitle: UITextField!
    @IBOutlet weak var ideaSummary: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didPushPostButton(button: UIBarButtonItem) {
        
        selectedCardSpace.info["ideaTitle"] = ideaTitle.text!
        selectedCardSpace.info["ideaPreview"] = ideaSummary.text!
        
        self.startedCreatingPost()
        ServerInterface.addCard(selectedCardSpace) {
            self.finishedCreatingPost()
            
        }
        
    }
    
    override func isReadyForPosting() -> Bool {
        return ideaTitle.text! != "" && ideaSummary.text != ""
    }
    
}

class QuestionPostController : PosterController {
    
    @IBOutlet weak var questionTitle: UITextField!
    @IBOutlet weak var questionSummary: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didPushPostButton(button: UIBarButtonItem) {
        selectedCardSpace.info["questionTitle"] = questionTitle.text!
        selectedCardSpace.info["questionPreview"] = questionSummary.text!
        
        self.startedCreatingPost()
        ServerInterface.addCard(selectedCardSpace) {
            self.finishedCreatingPost()
        }
        
        self.performSegueWithIdentifier("backToSpaceSelectorSegue", sender: self)
    }
    
    override func isReadyForPosting() -> Bool {
        return questionTitle.text! != "" && questionSummary.text != ""
    }
    
}

class RFPPostController : PosterController {
    
    @IBOutlet weak var RFPTitle: UITextField!
    @IBOutlet weak var RFPSummary: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didPushPostButton(button: UIBarButtonItem) {
        
        selectedCardSpace.info["RFPTitle"] = RFPTitle.text!
        selectedCardSpace.info["RFPPreview"] = RFPSummary.text!
        
        self.startedCreatingPost()
        ServerInterface.addCard(selectedCardSpace) {
            self.finishedCreatingPost()
            
        }
    }
    
    override func isReadyForPosting() -> Bool {
        return RFPTitle.text! != "" && RFPSummary.text != ""
    }
}