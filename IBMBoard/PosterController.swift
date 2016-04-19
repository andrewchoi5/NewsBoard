//
//  PosterController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-03.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class LoadingView : UIView {}

class PosterController : KeyboardPresenter {
    
    private var activityIndicator = UIActivityIndicatorView()
    private var loadingScreen = LoadingView()
    
    var selectedCardSpace : Card = Card()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        loadingScreen.hidden = true
        loadingScreen.alpha = 0.7
        loadingScreen.backgroundColor = UIColor.blackColor()
        loadingScreen.userInteractionEnabled = false
        
        self.view.addSubview(loadingScreen)
        loadingScreen.addSubview(activityIndicator)

    }
    
    func startedCreatingPost() {
        self.view.bringSubviewToFront(loadingScreen)
        loadingScreen.bringSubviewToFront(activityIndicator)
        loadingScreen.hidden = false
        self.view.userInteractionEnabled = false
        activityIndicator.startAnimating()
        
    }
    
    func finishedCreatingPost() {
        self.view.userInteractionEnabled = true
        loadingScreen.hidden = true
        activityIndicator.stopAnimating()
        self.performSegueWithIdentifier("backToLoginSegue", sender: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loadingScreen.frame = self.view.bounds
        
        activityIndicator.center.x = self.view.frame.width / 2
        activityIndicator.center.y = self.view.frame.height / 2
    }
    
    func changeTitleColorOfBarButtonItem(item : UIBarButtonItem) {
        
        let normalAttributes = [
            
            NSForegroundColorAttributeName: UIColor.mainAccentGreen()
            
        ]
        
        let disabledAttributes = [
            
            NSForegroundColorAttributeName: UIColor.secondaryTextColor()
            
        ]
        
        item.setTitleTextAttributes(normalAttributes, forState: .Normal)
        item.setTitleTextAttributes(disabledAttributes, forState: .Disabled)
        
    }
    
    func enableBarButtonItem() {
        
    }
}

extension PosterController : UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.enableBarButtonItem()
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.enableBarButtonItem()
        
    }
    
}

class PlaceholderPosterController : PosterController {
    
    
    
}