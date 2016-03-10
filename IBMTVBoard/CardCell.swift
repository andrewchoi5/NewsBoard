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

struct Space {
    
    var topLeftCorner : Int
    var width : Int
    var height : Int
    
    init(corner: Int, aWidth: Int, aHeight: Int) {
        
        topLeftCorner = corner
        width = aWidth
        height = aHeight
    }
    
    init(dictionary: [String: Int]) {
        
        topLeftCorner = dictionary["topLeftCorner"]!
        width = dictionary["width"]!
        height = dictionary["height"]!
        
    }
    
}

class Card : Document {
    
    var type : CardCellType!
    var space : Space!
    var attachmentURLString : String {
        guard let attachmentName = super.getAttachments().keys.first else { return "" }
        return "https://b66668a3-bd4d-4e32-88cc-eb1e0bff350b-bluemix.cloudant.com/ibmboard/\(self.id)/\(attachmentName)"
    }
    
    init(cardType: CardCellType, corner: Int, aWidth: Int, aHeight: Int) {
        super.init()
        
        space = Space(corner: corner, aWidth: aWidth, aHeight: aHeight)
        type = cardType
    }
    
    init(corner: Int, aWidth: Int, aHeight: Int) {
        super.init()
        
        space = Space(corner: corner, aWidth: aWidth, aHeight: aHeight)
        type = .Default

    }
    
    override init(document: Document) {
        super.init(document: document)
        
        type = CardCellType(rawValue: document.info["type"] as! Int)
        info = document.info["info"] as! [String : AnyObject]
        space = Space(dictionary: document.info["space"]  as! [String : Int])
    }
    
    override init() {
        super.init()
    }
    
}

class CardCell : UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    
    var oldColor : UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userPhoto.layer.cornerRadius = userPhoto.frame.size.width / 2
    }
    
    func applyCardContent(card: Card) {
        
    }
    
    func focus() {
        oldColor = self.backgroundColor
        self.backgroundColor = UIColor.redColor()
        
    }
    
    func defocus() {
        self.backgroundColor = oldColor
    }
    
    override func prepareForReuse() {
        self.defocus()
    }
}

class AnnouncementCardCell : CardCell {
    
    @IBOutlet weak var announcementPhoto: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var announcementText: UILabel!
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
    
        announcementPhoto.sd_setImageWithURLString(card.attachmentURLString, progressBlock: { (expectedSize, totalSize) in
            self.progressBar.setProgress(Float(expectedSize) / Float(totalSize), animated: true)
            
            }, completion: {(image, error, cacheType, url) in
            self.progressBar.removeFromSuperview()
            
        })
                        
        titleLabel.text = "Announcement"
        announcementText.text =  card.info["announcementText"] as? String
        
    }
}

class ArticleCardCell : CardCell {
    
    @IBOutlet weak var articleMessageBody: UILabel!
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
        
        titleLabel.text = card.info["articleTitle"] as? String
        articleMessageBody.text = card.info["articlePreviewText"] as? String
    }
    
}

class VideoCardCell : CardCell {
    @IBOutlet weak var videoPreview: UIImageView!
    
    override func applyCardContent(card: Card) {
        super.applyCardContent(card)
        titleLabel.text = card.info["videoTitle"] as? String
        videoPreview.sd_setImageWithURL(VideoAPIManager.getAPIURL(card.info["videoURL"] as! String))

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let view = UIView(frame: videoPreview.frameForImage())
        view.alpha = 0.4
        view.backgroundColor = UIColor.blackColor()
        view.tag = 1
        self.viewWithTag(1)?.removeFromSuperview()
        self.addSubview(view)
        
        self.bringSubviewToFront(self.viewWithTag(2)!)
    }
    
}