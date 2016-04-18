//
//  ProfilePictureController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-17.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class ProfilePictureController : UIViewController {
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var accountForProfilePicture : Account!
    var selectedImage : UIImage!
    
    @IBAction func didChooseCameraOption() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .Camera
        vc.cameraDevice = .Front
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func didChooseAlbumOption() {
        
        
        let vc = UIImagePickerController()
        vc.sourceType = .SavedPhotosAlbum
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func didAttemptToUploadPicture() {
        if selectedImage == nil {
            return
            
        }
        
        accountForProfilePicture.setProfilePicture(selectedImage)
        showLoading()
        ServerInterface.updateAccount(accountForProfilePicture) {
            self.hideLoading()
            self.performSegueWithIdentifier("profilePictureUploadSuccessSegue", sender: self)
            
        }
        
    }
    
    func showLoading() {
        ServerInterface.delegateProxy.forwardMessagesTo(self)
        loadingScreen.alpha = 0.4
        progressBar.hidden = false
    }
    
    func hideLoading() {
        ServerInterface.delegateProxy.forwardMessagesTo(nil)
        loadingScreen.alpha = 0
        progressBar.hidden = true
    }
        
    override func viewDidAppear(animated: Bool) {
        if selectedImage != nil {
            profilePictureView.image = selectedImage
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width / 2
    }
    
}

extension ProfilePictureController : NSURLSessionTaskDelegate {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        dispatch_async(dispatch_get_main_queue(), {
            self.progressBar.setProgress(Float(totalBytesSent) / Float(totalBytesExpectedToSend), animated: true)
        })
    }
    
}

extension ProfilePictureController : UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension ProfilePictureController : UINavigationControllerDelegate { }