//
//  ArticlePosterController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class ArticlePosterController : PosterController, UITextFieldDelegate {
    
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
    
    func loadPreview() {
        articlePreviewBody.text = APIManager.getArbitraryTextArticlePreview(articleLink.text!)
        articleTitle.text = APIManager.getArbitraryTextArticleTitle()
    }
    
    @IBAction func didPushPostArticleButton() {
        selectedCardSpace.info["articleURL"] = articleLink.text!
        selectedCardSpace.info["articleTitle"] = articleTitle.text!
        selectedCardSpace.info["articlePreviewText"] = articlePreviewBody.text
        
        ServerInterface.postCard(selectedCardSpace, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }

}