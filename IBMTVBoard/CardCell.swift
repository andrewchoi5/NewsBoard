//
//  CardCell.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-26.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

enum CardCellType : Int {
    
    case Default
    case Announcement
    case RFP
    case Video
    case NewsArticle
    case Idea
    case Polling
    case Question
    case Guest
    
}

class CardCell : UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var cardBackgroundView: UIView!
    @IBOutlet weak var cardGradientBorderView: GradientView!
    @IBOutlet weak var cardTypeLabel: UILabel!
    
    var oldColor : UIColor!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width / 2
        
        cardBackgroundView.layer.shadowOpacity = 0.2
        cardBackgroundView.layer.shadowRadius = 2.0
        cardBackgroundView.layer.shadowOffset = CGSizeMake(-1.0, 5.0)
        
        cardTypeLabel.kern(2.0);
    }
    
    func applyCardContent(card: Card) {
        ServerInterface.getAccount(associatedWithCard: card) { (account) in
            self.userPhoto.sd_setImageWithURL(account?.profilePictureURL) { (image, error, cacheType, url) in
                // TODO: Put activity indicator logic here
                
            }
            
        }

        
    }
    
    func updateCardContent(card: Card) {
        
    }
    
    func focus() {
        cardGradientBorderView.hidden = false;
        cardBackgroundView.layer.shadowOpacity = 0;
    }
    
    func defocus() {
        cardGradientBorderView.hidden = true;
        cardBackgroundView.layer.shadowOpacity = 0.2;
    }
    
    override func prepareForReuse() {
        self.defocus()
        
    }
}

extension UIView {
    
    func constraintWithID(ID: String) -> NSLayoutConstraint? {
        if ID == "" {
            return nil
        }
        
        for constraint in constraints {
            if constraint.identifier == ID {
                return constraint
            }
        }
        
        return nil
    }
    
}

class AnnouncementCardCell : CardCell {
    
    static let photoHeightConstraintID = "messageBodyHeightConstraint"
    
    @IBOutlet weak var announcementPhoto: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var announcementText: UILabel!
    
    private var hasPhoto : Bool = false
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
    
        if let title = card.info["announcementTitle"] as? String {
            titleLabel.text = title
            
        } else {
            titleLabel.text = "Announcement"
            
        }
        
        announcementText.text =  card.info["announcementText"] as? String
        
        if let image = card.attachedImage {
            progressBar.hidden = true
            announcementPhoto.image = image
            hasPhoto = true
            
        } else if let imageURL = card.attachedImageURL {
            announcementPhoto.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "emptyProfilePic")!, progressBlock: { (expectedSize, totalSize) in
                self.progressBar.setProgress(Float(expectedSize) / Float(totalSize), animated: true)
                
                }, completion: {(image, error, cacheType, url) in
                    if ((error == nil)) {
                        let BWphoto = convertToGrayScale(self.announcementPhoto.image!)
                        self.announcementPhoto.image = BWphoto;
                        self.announcementPhoto.hidden = false;
                    }
                    self.progressBar.hidden = true
            })
            hasPhoto = true
            
        } else if let userProvidedURL = card.userProvidedURL {
            announcementPhoto.sd_setImageWithURLString(userProvidedURL.absoluteString, progressBlock: { (expectedSize, totalSize) in
                self.progressBar.setProgress(Float(expectedSize) / Float(totalSize), animated: true)
                
                }, completion: {(image, error, cacheType, url) in
                    if ((error == nil)) {
                        let BWphoto = convertToGrayScale(self.announcementPhoto.image!)
                        self.announcementPhoto.image = BWphoto;
                        self.announcementPhoto.hidden = false;
                    }
                    self.progressBar.hidden = true
            })
            hasPhoto = true
            
        } else {
            self.progressBar.hidden = true
            
        }
        
    }
    
    func hidePhoto() {
        if let constraint = announcementText.constraintWithID(AnnouncementCardCell.photoHeightConstraintID) {
            constraint.active = false
        }
    }
    
    func showPhoto() {
        if let constraint = announcementText.constraintWithID(AnnouncementCardCell.photoHeightConstraintID) {
            constraint.active = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        showPhoto()
        self.announcementPhoto.image = nil
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if !hasPhoto {
            hidePhoto()
            
        }
    }
}

class ArticleCardCell : CardCell {
    
    @IBOutlet weak var articleMessageBody: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
        
        titleLabel.text = card.info["articleTitle"] as? String
        articleMessageBody.text = card.info["articlePreviewText"] as? String
        
        detailLabel.text = "Read More..."
        
    }
    
}

class VideoCardCell : CardCell {
    @IBOutlet weak var videoPreview: UIImageView!
    @IBOutlet weak var greyBox: UIView!
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
        titleLabel.text = card.info["videoTitle"] as? String
        videoPreview.sd_setImageWithURL(VideoAPIManager.getAPIURL(card.info["videoURL"] as! String)) { (image, error, cacheType, url) -> Void in
            if ((error == nil)) {
                let BWphoto = convertToGrayScale(self.videoPreview.image!)
                self.videoPreview.image = BWphoto;
                self.videoPreview.hidden = false;
            }
            self.greyBox.hidden = error != nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        greyBox.frame = videoPreview.frameForImage()
        
    }
    
}

class IdeaCardCell : ArticleCardCell {
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
        
        titleLabel.text = card.info["ideaTitle"] as? String
        articleMessageBody.text = card.info["ideaPreview"] as? String
        
        detailLabel.text = "More details..."
        
    }
    
}

class RFPCardCell : ArticleCardCell {
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
        
        titleLabel.text = card.info["RFPTitle"] as? String
        articleMessageBody.text = card.info["RFPPreview"] as? String
        
        detailLabel.text = ""
        
    }
    
}

func convertToGrayScale(image: UIImage) -> UIImage {
    let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
    let colorSpace = CGColorSpaceCreateDeviceGray()
    let width = image.size.width
    let height = image.size.height
    
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
    let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
    
    CGContextDrawImage(context, imageRect, image.CGImage)
    let imageRef = CGBitmapContextCreateImage(context)
    let newImage = UIImage(CGImage: imageRef!)
    
    return newImage
}