//
//  UIFont.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-22.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func defaultFontOfSize(size: Double) -> UIFont {
        return UIFont(name:"Roboto", size: CGFloat(size))!
        
    }
    
    static func defaultBoldFontOfSize(size: Double) -> UIFont {
        return UIFont(name:"Roboto-bold", size: CGFloat(size))!
        
    }
    
}