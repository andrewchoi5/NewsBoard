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
    @IBOutlet weak var photoView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(photoView != nil) {
            photoView.layer.cornerRadius = photoView.frame.size.width / 2            
        }
    }
    
    func setPhoto(image: UIImage) {
        guard let view = photoView else { return }
        view.image = image
    }
    
}
