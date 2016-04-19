//
//  UIColorExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-17.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
        
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)

    }
}

extension UIColor {
    
    static func primaryBlue() -> UIColor {
        return UIColor.init(r: 30, g: 118, b: 227)
        
    }
    
    static func buttonBlue() -> UIColor {
        return UIColor.init(r: 41, g: 149, b: 243)
        
    }
    
    static func textWhite() -> UIColor {
        return UIColor.whiteColor()
        
    }
    
    static func errorRed() -> UIColor {
        return UIColor.init(r: 255, g: 102, b: 102)
        
    }
    
    static func mainAccentGreen() -> UIColor {
        return UIColor.init(r: 91, g: 255, b: 111)
        
    }
    
    static func backgroundDarkColor() -> UIColor {
        return UIColor.init(r: 36, g: 40, b: 46)
        
    }
    
    static func secondaryTileColor() -> UIColor {
        return UIColor.init(r: 63, g: 69, b: 77)
        
    }
    
    static func secondaryTextColor() -> UIColor {
        return UIColor.init(r: 127, g: 132, b: 140)
        
    }
}