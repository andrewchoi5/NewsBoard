//
//  ArticlePosterController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class ArticlePosterController : UIViewController, UITextFieldDelegate {
    
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
    }
    
    @IBAction func didPushPostArticleButton() {
        
        ServerInterface.postArticle(articleLink.text!, articleTitle:articleTitle.text!, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
        
    }

}