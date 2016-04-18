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
    
    public func sd_setImageWithURL(url : NSURL, completion:SDWebImageCompletionBlock) {
        self.sd_setImageWithURL(url, completed: completion)
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
        
    public func sd_setImageWithURL(url : NSURL, progressBlock : SDWebImageDownloaderProgressBlock, completion:SDWebImageCompletionBlock) {
        self.sd_setImageWithURL(url, placeholderImage:nil, options:SDWebImageOptions(rawValue: 0), progress:progressBlock, completed:completion)

    }

}

extension UIImageView {
    
    func viewFrameAspectRatio() -> CGFloat {
        return self.frame.width / self.frame.height
        
    }
    
    func expectedImageAspectRatio() -> CGFloat {
        guard let size = self.image?.size else { return 1.0 }
        return size.width / size.height
        
    }
    
    func frameForImage() -> CGRect {
        
        let xOffsetForFrame : CGFloat = 0.0
        let yOffsetForFrame : CGFloat = 0.0
        
        var rect = CGRect()
        
        if(viewFrameAspectRatio() > expectedImageAspectRatio()) {
            rect.size.height = frame.height
            rect.size.width = frame.height * expectedImageAspectRatio()
            
        } else if(viewFrameAspectRatio() < expectedImageAspectRatio()) {
            rect.size.height = frame.width / (expectedImageAspectRatio())
            rect.size.width = frame.width
            
        } else {
            rect.size.height = frame.height
            rect.size.width = frame.width
            
        }
        
        rect.origin.x = (self.frame.width - rect.size.width) / 2 + xOffsetForFrame + self.frame.origin.x
        rect.origin.y = (self.frame.height - rect.size.height) / 2 + yOffsetForFrame  + self.frame.origin.y
        
        return rect
        
    }
    
}