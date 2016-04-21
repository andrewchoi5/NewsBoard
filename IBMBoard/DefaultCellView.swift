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
    
    // cross lines
    var line : UIView!
    var line2 : UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        line = UIView()
        line2 = UIView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add cross
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.darkTextColor().colorWithAlphaComponent(0.05)
        
        clipsToBounds = true // Cut off everything outside the view
        
        addSubview(line)
        
        // Define line width
        line.addConstraint(NSLayoutConstraint(item: line, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1))
        
        // Set up line length constraint
        let lengthConstraint = NSLayoutConstraint(item: line, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
        addConstraint(lengthConstraint)
        
        // Center line in view
        addConstraint(NSLayoutConstraint(item: line, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: line, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        lengthConstraint.constant = sqrt(pow(frame.size.width, 2) + pow(frame.size.height, 2))
        line.transform = CGAffineTransformMakeRotation(atan2(frame.size.height, frame.size.width))
        
        
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.backgroundColor = UIColor.darkTextColor().colorWithAlphaComponent(0.05)
        
        addSubview(line2)
        
        // Define line width
        line2.addConstraint(NSLayoutConstraint(item: line2, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1))
        
        // Set up line length constraint
        let lengthConstraint2 = NSLayoutConstraint(item: line2, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
        addConstraint(lengthConstraint2)
        
        // Center line in view
        addConstraint(NSLayoutConstraint(item: line2, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: line2, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        lengthConstraint2.constant = sqrt(pow(frame.size.width, 2) + pow(frame.size.height, 2))
        line2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) - atan2(frame.size.height, frame.size.width))
    
    }
    
    func hideCross() {
        line2.hidden = true;
        line.hidden = true;
    }
    
}