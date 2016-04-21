//
//  AnnoucementPostController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-25.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

class AnnouncementPostController : PosterController {
    
    @IBOutlet weak var addPictureButton: FormButton!
    @IBOutlet weak var announcementTitle: UITextField!
    @IBOutlet weak var announcementText: UITextView!
    @IBOutlet weak var announcementPhotoURL: UITextField!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usesProgressBar = true
    }
    
    func defaultActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Take Picture"
            , style: .Default, handler: { (action) in
                
            self.presentCameraImageController()

        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Choose from Album", style: .Default, handler: { (action) in
            
            self.presentPhotoAlbumController()

        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .Cancel, handler: { (action) in
            
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        return actionSheet
    }
    
    override func isReadyForPosting() -> Bool {
        // && (announcementPhotoURL.text == nil || (announcementPhotoURL.text != nil && NSURL(string: announcementPhotoURL.text!) != nil))
        
        return announcementTitle.text != "" && announcementText.text != "" && (selectedImage?.CGImage != nil || announcementPhotoURL.text != "")
        
    }
    
    override func didPushPostButton(sender: UIBarButtonItem) {
        
        if let userPhotoURLString = announcementPhotoURL.text {
            guard let _ = NSURL(string: userPhotoURLString) else { return }
            selectedCardSpace.info["userPhotoURL"] = userPhotoURLString
        }
        
        selectedCardSpace.info["announcementTitle"] = announcementTitle.text
        selectedCardSpace.info["announcementText"] = announcementText.text

        
        if let image = selectedImage {
            selectedCardSpace.attachPNGImage(image)
            
        }
        
        
        self.startedCreatingPost()
        ServerInterface.addCard(selectedCardSpace, completion: {
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
        
        self.presentViewController(defaultActionSheet(), animated: true, completion: nil)
    }
    
}

extension AnnouncementPostController : UINavigationControllerDelegate { }

extension AnnouncementPostController : UIImagePickerControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        addPictureButton.setTitle("Change picture", forState: .Normal)
        postButton.enabled = isReadyForPosting()

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}