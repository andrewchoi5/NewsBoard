//
//  DefaultCellView.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class DefaultCellView : UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
//        self.layer.borderColor = UIColor(white: 2.0 / 3.0, alpha: 0.5).CGColor
//        self.layer.borderWidth = 0.5
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        if(photoView != nil) {
//            photoView.layer.cornerRadius = photoView.frame.size.width / 2            
//        }
    }
    
//    func setPhoto(image: UIImage) {
//        guard let view = photoView else { return }
//        view.image = image
//    }
    
}
