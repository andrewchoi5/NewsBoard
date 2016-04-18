//
//  UIImageExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func orientedCorrectly() -> UIImage? {
    
        if self.imageOrientation == .Up {
            return self
        }
        
        var transform = CGAffineTransformIdentity
        
        if self.imageOrientation == .Down || self.imageOrientation == .DownMirrored {
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            
        }
        
        if self.imageOrientation == .Left || self.imageOrientation == .LeftMirrored {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            
        }
        
        if self.imageOrientation == .Right || self.imageOrientation == .RightMirrored {
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            
        }
        
        if self.imageOrientation == .UpMirrored || self.imageOrientation == .DownMirrored {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        }
        
        if self.imageOrientation == .LeftMirrored || self.imageOrientation == .RightMirrored {
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        }
        
        let context = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage).rawValue)
        
        CGContextConcatCTM(context, transform)
        
        if self.imageOrientation == .RightMirrored {
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
            
        } else {
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage)
            
        }
        
        guard let cgImage = CGBitmapContextCreateImage(context) else { return nil }
        return UIImage(CGImage: cgImage)
    }
    
}