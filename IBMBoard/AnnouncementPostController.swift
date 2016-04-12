//
//  AnnoucementPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-25.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class AnnouncementPostController : PosterController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionTaskDelegate {
    
    @IBOutlet weak var announcementTitle: UITextField!
    @IBOutlet weak var announcementText: UITextView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var announcementPhotoURL: UITextField!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func didPushPostButton(sender: UIButton) {
        
        if !progressBar.hidden {
            return
        }
        
        guard let title = announcementTitle.text else { return }
        guard let text = announcementText.text else { return }
        if let userPhotoURLString = announcementPhotoURL.text {
            guard let _ = NSURL(string: userPhotoURLString) else { return }
            selectedCardSpace.info["userPhotoURL"] = userPhotoURLString
        }

        selectedCardSpace.info["announcementTitle"] = title
        selectedCardSpace.info["announcementText"] = text

        
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