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
    private var cancelCurrentUpload = false
    
    var usesProgressBar : Bool = false
    var card : Card = Card()
    var updatingMode = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if updatingMode {
            prepareToUpdateWithCardContent()
        }
        
        self.lockToPortrait()
        
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
        if !updatingMode {
            ServerInterface.deleteCard(card, completion: nil)
        }
        
    }
    
    func prepareToUpdateWithCardContent() {
        
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
        postButton.title = updatingMode ? "Update" : "Post"
        postButton.enabled = isReadyForPosting()
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
    
    private func defaultPhotoOptionActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Picture"
            , style: .Default, handler: { (action) in
                
                self.presentCameraImageController()
                
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose from Album", style: .Default, handler: { (action) in
            
                self.presentPhotoAlbumController()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        return actionSheet
    }
    
    func presentImageSelectionOptions() {
        self.presentViewController(defaultPhotoOptionActionSheet(), animated: true, completion: nil)
    }
    
    private func presentPhotoAlbumController() {
        let vc = UIImagePickerController()
        vc.sourceType = .SavedPhotosAlbum
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    private func presentCameraImageController() {
        let vc = UIImagePickerController()
        vc.sourceType = .Camera
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    private func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PosterController.didReceiveTextFieldChangedNotification(_:)), name: UITextFieldTextDidChangeNotification, object: nil)

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
        
        postButton.enabled = isReadyForPosting()
        self.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem = nil
        
        if usesProgressBar {
            progressBar.hidden = true
            ServerInterface.delegateProxy.forwardMessagesTo(nil)
            
            
        } else {
            activityIndicator.stopAnimating()
            
        }
    }
    
    func startLoadingState() {
        self.startLoading()
        
    }
    
    func endLoadingState() {
        self.endLoading()
        self.performSegueWithIdentifier("backToSpaceSelectorSegue", sender: self)
        
    }
    
    func finish() {
        if updatingMode {
            self.updateCard(card)
            
        } else {
            self.addCard(card)
            
        }
        
    }
    
    private func updateCard(card : Card) {
        self.startLoadingState()
        ServerInterface.updateCard(card) {
            self.endLoadingState()
            
        }
        
    }
    
    private func addCard(card : Card) {
        self.startLoadingState()
        ServerInterface.addCard(card) {
            self.endLoadingState()
            
        }
        
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
    
    func didReceiveTextFieldChangedNotification(notification: NSNotification) {
        textFieldDidChange(notification.object as! UITextField)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        postButton.enabled = isReadyForPosting()
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        postButton.enabled = isReadyForPosting()
        
    }
    
    func textFieldDidChange(textField : UITextField) {
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

extension PosterController : UINavigationControllerDelegate { }

extension PosterController : UIImagePickerControllerDelegate {
    
    func didChooseNewImage(image : UIImage) {

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        didChooseNewImage(info[ UIImagePickerControllerOriginalImage ] as! UIImage)
        picker.dismissViewControllerAnimated(true, completion: nil)
        postButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class PlaceholderPosterController : PosterController {
    
}