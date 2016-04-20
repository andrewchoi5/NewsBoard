//
//  PosterController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-03.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

protocol PosterControllerDelegate {
    
    func didPushPostButton(button : UIBarButtonItem)
    
}

class PosterController : KeyboardPresenter {
    
    private var activityIndicator : UIActivityIndicatorView!
    private var progressBar : UIProgressView!
    private var loadingScreen : UIView!
    private var postButton : UIBarButtonItem!
    private var cancelButton : UIBarButtonItem!
    
    var usesProgressBar : Bool = false
    var selectedCardSpace : Card = Card()

    private var cancelCurrentUpload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = defaultActivityIndicator()
        loadingScreen = defaultLoadingScreen()
        postButton = defaultPostButton()
        progressBar = defaultProgressBar()
        cancelButton = defaultCancelButton()
        
        self.view.addSubview(loadingScreen)
        loadingScreen.addSubview(activityIndicator)
        loadingScreen.addSubview(progressBar)
        self.navigationItem.rightBarButtonItem = postButton
        
        registerForNotifications()

    }
    
    @objc private func didPushCancel() {
        self.endLoading()
        cancelCurrentUpload = true
        ServerInterface.deleteCard(selectedCardSpace, completion: nil)
        
    }
    
    private func defaultCancelButton() -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.title = "Cancel"
        button.target = self
        button.action = #selector(PosterController.didPushCancel)
        return button
    }
    
    private func defaultProgressBar() -> UIProgressView {
        let progressBar = UIProgressView()
        progressBar.hidden = true
        progressBar.progress = 0.0
        progressBar.clipsToBounds = true
        return progressBar
    }
    
    private func defaultLoadingScreen() -> UIView {
        let loadingScreen = UIView()
        loadingScreen.hidden = true
        loadingScreen.alpha = 0.7
        loadingScreen.backgroundColor = UIColor.blackColor()
        loadingScreen.userInteractionEnabled = false
        
        return loadingScreen
        
    }
    
    private func defaultActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }
    
    private func defaultPostButton() -> UIBarButtonItem {
        let postButton = UIBarButtonItem()
        postButton.title = "Post"
        postButton.enabled = false
        postButton.action = #selector(PosterController.didPushPostButton(_:))
        postButton.target = self
        
        let normalAttributes = [
            
            NSForegroundColorAttributeName: UIColor.mainAccentGreen()
            
        ]
        
        let disabledAttributes = [
            
            NSForegroundColorAttributeName: UIColor.secondaryTextColor()
            
        ]
        
        postButton.setTitleTextAttributes(normalAttributes, forState: .Normal)
        postButton.setTitleTextAttributes(disabledAttributes, forState: .Disabled)
        
        return postButton
    }
    
    private func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:         #selector(PosterController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)

    }
    
    private func startLoading() {
        self.view.bringSubviewToFront(loadingScreen)
        loadingScreen.hidden = false
        self.view.userInteractionEnabled = false
        
        postButton.enabled = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = cancelButton
        
        if usesProgressBar {
            loadingScreen.bringSubviewToFront(progressBar)
            progressBar.hidden = false
            ServerInterface.delegateProxy.forwardMessagesTo(self)
            
        } else {
            loadingScreen.bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
            
        }
    }
    
    private func endLoading() {
        self.view.userInteractionEnabled = true
        loadingScreen.hidden = true
        
        postButton.enabled = true
        self.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem = nil
        
        if usesProgressBar {
            progressBar.hidden = true
            ServerInterface.delegateProxy.forwardMessagesTo(nil)
            
            
        } else {
            activityIndicator.stopAnimating()
            
        }
    }
    
    func startedCreatingPost() {
        self.startLoading()
        
    }
    
    func finishedCreatingPost() {
        self.endLoading()
        self.performSegueWithIdentifier("backToSpaceSelectorSegue", sender: self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loadingScreen.frame = self.view.bounds
        
        activityIndicator.center.x = self.view.frame.width / 2
        activityIndicator.center.y = self.view.frame.height / 2
        
        progressBar.center.x = self.view.frame.width / 2
        progressBar.center.y = self.view.frame.height / 2
        progressBar.frame.size.width = self.view.frame.size.width - 100.0
    }
    
    func isReadyForPosting() -> Bool {
        return true
        
    }

}

extension PosterController : PosterControllerDelegate {
    
    func didPushPostButton(button : UIBarButtonItem) {
        
        
    }
    
}

extension PosterController : UITextFieldDelegate, UITextViewDelegate {
    
    // NOTE: This method is not provided by default by UITextFieldDelegate,
    // an instance of this class is configured to register itself for notifications to
    // use it
    func textFieldDidChange(textField: UITextField) {
        postButton.enabled = isReadyForPosting()

    }
    
    func textViewDidChange(textView: UITextView) {
        postButton.enabled = isReadyForPosting()

    }

    
}

extension PosterController : NSURLSessionTaskDelegate {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        if cancelCurrentUpload {
            cancelCurrentUpload = false
            task.cancel()
            return
            
        }
        
        self.progressBar.setProgress(Float(totalBytesSent) / Float(totalBytesExpectedToSend), animated: true)
    }
    
}

class PlaceholderPosterController : PosterController {
    
}