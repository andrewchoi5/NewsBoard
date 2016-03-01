//
//  CardCell.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-26.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

enum CardCellType {
    
    case Default
    case Announcement
    case RFP
    case Video
    case NewsArticle
    case Idea
    
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