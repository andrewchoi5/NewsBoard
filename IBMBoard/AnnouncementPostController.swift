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
    
    var infoTitle = "announcementTitle"
    var infoText = "announcementText"
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usesProgressBar = true
    }
    
    override func prepareToUpdateWithCardContent() {
        announcementPhotoURL.text = card.info["userPhotoURL"] as? String
        announcementTitle.text = card.info[infoTitle] as? String
        announcementText.text = card.info[infoText] as? String
        
        if card.hasAttachments() {
            
            addPictureButton.setTitle("Change picture", forState: .Normal)

        }
    }
    
    override func isReadyForPosting() -> Bool {
        return announcementTitle.text != "" && announcementText.text != ""
        
    }
    
    override func didPushPostButton(sender: UIBarButtonItem) {
        
        if let userPhotoURLString = announcementPhotoURL.text {
            guard let _ = NSURL(string: userPhotoURLString) else { return }
            card.info["userPhotoURL"] = userPhotoURLString
        }
        
        card.info[infoTitle] = announcementTitle.text
        card.info[infoText] = announcementText.text

        
        if let image = selectedImage {
            card.attachImage(image) {
                self.finish()
                
            }
            
        } else {
            self.finish()
            
        }
        
    }
    
    @IBAction func didPushAddPictureButton(sender: UIButton) {
        presentImageSelectionOptions()
        
    }
    
    override func didChooseNewImage(image: UIImage) {
        selectedImage = image
        addPictureButton.setTitle("Change picture", forState: .Normal)
    }
}

class IdeaPostController : AnnouncementPostController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTitle = "ideaTitle"
        self.infoText = "ideaPreview"
    }
    
}

class QuestionPostController : AnnouncementPostController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTitle = "questionTitle"
        self.infoText = "questionPreview"
    }
    
}

class RFPPostController : AnnouncementPostController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTitle = "RFPTitle"
        self.infoText = "RFPPreview"
    }
    
}