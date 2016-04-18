//
//  UILabelExt.swift
//  IBMBoard
//
//  Created by Andrew Frolkin on 2016-04-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension UILabel {
    
    func setKern(kerningValue: CGFloat) {
        self.attributedText =  NSAttributedString(string: text ?? "", attributes: [NSKernAttributeName:kerningValue, NSFontAttributeName: font, NSForegroundColorAttributeName: textColor])
    }
    
}