//
//  CardCell.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-26.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class CardCell : UICollectionViewCell {
    
    
    @IBOutlet weak var photoView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(red: 0.0, green: 25.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.layer.cornerRadius = photoView.frame.size.width / 2
    }
    
}