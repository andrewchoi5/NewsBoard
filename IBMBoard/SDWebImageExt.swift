//
//  SDWebImageExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func sd_setImageWithURLString(url : String) {
        self.sd_setImageWithURL(NSURL(string: url))
    }
    
    public func sd_setImageWithURLString(url : String, placeholderImage : UIImage) {
        self.sd_setImageWithURL(NSURL(string: url), placeholderImage: placeholderImage)
        
    }
}
