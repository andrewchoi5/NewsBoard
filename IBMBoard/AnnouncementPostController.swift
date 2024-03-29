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
    @IBOutlet weak var newBody: FormLabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var infoTitle = "announcementTitle"
    var infoText = "announcementText"
   
    var isPhotoView : Bool?
    
    var selectedImage : UIImage?
    
    var selectedTVName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isPhotoView == true) {
            announcementTitle.hidden = true
            announcementText.hidden = true
            newBody.hidden = true
            navTitle.title = "Photo"
        }
        
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
        if (isPhotoView == true) {
                return !(announcementPhotoURL.text?.isEmpty)!
        }
        
        return announcementTitle.text != "" && announcementText.text != ""
    }
    
    override func didPushPostButton(sender: UIBarButtonItem) {

        if let userPhotoURLString = announcementPhotoURL.text {
            guard let _ = NSURL(string: userPhotoURLString) else { return }
            card.info["userPhotoURL"] = userPhotoURLString
        }
        
        card.info[infoTitle] = announcementTitle.text
        card.info[infoText] = announcementText.text
        
        ServerInterface.getUser(associateWithAccount: SessionInformation.currentSession.userAccount, completion:{
            (user) in
            
            self.card.info["org"] = user?.org
            self.card.info["office"] = user?.office
            self.card.info["tv"] = self.selectedTVName
            
            
            if let image = self.selectedImage {
                self.card.attachImage(image) {
                    self.finish()
                    
                }
                
            } else {
                self.finish()
            }
            
        })
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.infoTitle = "ideaTitle"
        self.infoText = "ideaPreview"
    }
    
}

class QuestionPostController : AnnouncementPostController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.infoTitle = "questionTitle"
        self.infoText = "questionPreview"
    }
    
}

class RFPPostController : AnnouncementPostController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.infoTitle = "RFPTitle"
        self.infoText = "RFPPreview"
    }
    
}