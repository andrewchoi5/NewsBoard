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
    
    override func textFieldDidEndEditing(textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        
        if(textField == articleLink) {
            loadPreview()
        }
        
    }
    
    override func prepareToUpdateWithCardContent() {
        articleLink.text = card.info["articleURL"] as? String
        articleTitle.text = card.info["articleTitle"] as? String
        articlePreviewBody.text = card.info["articlePreviewText"] as? String

    }
    
    override func isReadyForPosting() -> Bool {
        return articlePreviewBody.text! != "" && articleTitle.text != ""
        
    }
    
    func loadPreview() {
        articlePreviewBody.text = APIManager.getArbitraryTextArticlePreview(articleLink.text!)
        articleTitle.text = APIManager.getArbitraryTextArticleTitle()
    }
    
    override func didPushPostButton(button : UIBarButtonItem) {
        card.info["articleURL"] = articleLink.text!
        card.info["articleTitle"] = articleTitle.text!
        card.info["articlePreviewText"] = articlePreviewBody.text
        
        self.finish()
        
    }

}

class IdeaPostController : PosterController {
    
    @IBOutlet weak var ideaTitle: UITextField!
    @IBOutlet weak var ideaSummary: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareToUpdateWithCardContent() {
        ideaTitle.text = card.info["ideaTitle"] as? String
        ideaSummary.text = card.info["ideaPreview"] as? String
        
    }
    
    override func didPushPostButton(button: UIBarButtonItem) {
        
        card.info["ideaTitle"] = ideaTitle.text!
        card.info["ideaPreview"] = ideaSummary.text!
        
        self.finish()
        
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
    
    override func prepareToUpdateWithCardContent() {
        questionTitle.text = card.info["questionTitle"] as? String
        questionSummary.text = card.info["questionPreview"] as? String
        
    }
    
    override func didPushPostButton(button: UIBarButtonItem) {
        card.info["questionTitle"] = questionTitle.text!
        card.info["questionPreview"] = questionSummary.text!
        
        self.finish()
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
    
    override func prepareToUpdateWithCardContent() {
        RFPTitle.text = card.info["RFPTitle"] as? String
        RFPSummary.text = card.info["RFPPreview"] as? String
        
    }
    
    override func didPushPostButton(button: UIBarButtonItem) {
        
        card.info["RFPTitle"] = RFPTitle.text!
        card.info["RFPPreview"] = RFPSummary.text!
        
        self.finish()
    }
    
    override func isReadyForPosting() -> Bool {
        return RFPTitle.text! != "" && RFPSummary.text != ""
        
    }
}