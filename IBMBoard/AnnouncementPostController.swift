//
//  AnnoucementPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-25.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class AnnouncementPostController : PosterController {
    
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var addPictureButton: FormButton!
    @IBOutlet weak var announcementTitle: UITextField!
    @IBOutlet weak var announcementText: UITextView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var announcementPhotoURL: UITextField!
    @IBOutlet weak var announcementPostButton: UIBarButtonItem!
    
    var selectedImage : UIImage?
    var actionSheet : UIAlertController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTitleColorOfBarButtonItem(announcementPostButton)
        
        createActionSheet()

    }
    
    func showLoading() {
        ServerInterface.delegateProxy.forwardMessagesTo(self)
        loadingScreen.alpha = 0.7
        progressBar.hidden = false
        self.view.userInteractionEnabled = false
    }
    
    func hideLoading() {
        ServerInterface.delegateProxy.forwardMessagesTo(nil)
        loadingScreen.alpha = 0
        progressBar.hidden = true
        self.view.userInteractionEnabled = true
    }
    
    func createActionSheet() {
        actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Take Picture"
            , style: .Default, handler: { (action) in
                
            self.presentCameraImageController()

        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Choose from Album", style: .Default, handler: { (action) in
            
            self.presentPhotoAlbumController()

        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .Cancel, handler: { (action) in
            
            self.actionSheet.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
    }
    
    @IBAction func didPushPostButton(sender: UIBarButtonItem) {
        
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
            selectedCardSpace.attachPNGImage(image)
        }
        
        
        self.showLoading()
        ServerInterface.addCard(selectedCardSpace, completion: {
            self.hideLoading()
            self.finishedCreatingPost()
        
        })
        
    }
    
    func presentPhotoAlbumController() {
        let vc = UIImagePickerController()
        vc.sourceType = .SavedPhotosAlbum
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func presentCameraImageController() {
        let vc = UIImagePickerController()
        vc.sourceType = .Camera
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func didPushAddPictureButton(sender: UIButton) {
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    override func enableBarButtonItem() {
        announcementPostButton.enabled = true
    }
    
}

extension AnnouncementPostController : UINavigationControllerDelegate { }

extension AnnouncementPostController : UIImagePickerControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        addPictureButton.setTitle("Change picture", forState: .Normal)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension AnnouncementPostController : NSURLSessionTaskDelegate {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        dispatch_async(dispatch_get_main_queue(), {
            self.progressBar.setProgress(Float(totalBytesSent) / Float(totalBytesExpectedToSend), animated: true)
        })
    }
    
}