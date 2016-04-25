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
            // disable for now
            //loadPreview()
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