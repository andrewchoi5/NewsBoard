//
//  AnnoucementPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-25.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class AnnouncementPostController : PosterController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionTaskDelegate {
    
    @IBOutlet weak var announcementText: UITextView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func didPushPostButton(sender: UIButton) {
        
        if !progressBar.hidden {
            return
        }
        
        selectedCardSpace.info["announcementText"] = announcementText.text!
        if let image = selectedImage {
            selectedCardSpace.addPNGImage(image)
        }
        
        progressBar.hidden = false
        
        ServerInterface.delegateProxy.forwardMessagesTo(self)
        
        ServerInterface.addCard(selectedCardSpace, completion: {
            self.navigationController?.popViewControllerAnimated(true)

        
        })
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        dispatch_async(dispatch_get_main_queue(), {
            self.progressBar.setProgress(Float(totalBytesSent) / Float(totalBytesExpectedToSend), animated: true)
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func didPushPhotoAlbumButton(sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .SavedPhotosAlbum
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}