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

class Card : NSObject {
    
    var type : CardCellType!
    var info : Dictionary<String, AnyObject>!
    var space : Space!
    
    
    init(cardType: CardCellType, corner: Int, aWidth: Int, aHeight: Int) {

        space = Space(corner: corner, aWidth: aWidth, aHeight: aHeight)
        type = cardType
        info = Dictionary<String, AnyObject>()
    }
    
    init(corner: Int, aWidth: Int, aHeight: Int) {
        
        space = Space(corner: corner, aWidth: aWidth, aHeight: aHeight)
        type = .Default
        info = Dictionary<String, AnyObject>()

    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        type = CardCellType(rawValue: dictionary["type"] as! Int)
        info = dictionary["info"] as! [String : AnyObject]
        space = Space(dictionary: dictionary["space"]  as! [String : Int])
    }
    
    override init() {
        super.init()
    }
}

class CardCell : UICollectionViewCell {
    
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
    
    func focus() {
        oldColor = self.backgroundColor
        self.backgroundColor = UIColor.redColor()
        
    }
    
    func defocus() {
        self.backgroundColor = oldColor
    }
}