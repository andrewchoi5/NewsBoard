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
    
    public func sd_setImageWithURLString(url : String, placeholderImage : UIImage, progressBlock:SDWebImageDownloaderProgressBlock, completion:SDWebImageCompletionBlock) {
        self.sd_setImageWithURL(NSURL(string: url)!, placeholderImage:placeholderImage, options:SDWebImageOptions(rawValue: 0), progress:progressBlock, completed:completion)
        
    }
    
    public func sd_setImageWithURLString(url : String, progressBlock : SDWebImageDownloaderProgressBlock, completion:SDWebImageCompletionBlock) {
        self.sd_setImageWithURL(NSURL(string: url)!, placeholderImage:nil, options:SDWebImageOptions(rawValue: 0), progress:progressBlock, completed:completion)
        
    }
}
