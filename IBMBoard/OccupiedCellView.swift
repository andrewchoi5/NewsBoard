//
//  OccupiedCellView.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-21.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class OccupiedCellView : DefaultCellView {
    
    // cross lines
    var line : UIView!
    var line2 : UIView!
    // box for indicating position of card within the cell
    var greyBox : UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        line = UIView()
        line2 = UIView()
        greyBox = UIView()
        
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
    
    // when each flag is set to false, the rectangle takes up the full cell
    // when for example, the topEmpty flag is set to true, then top top of the rect will be empty
    func drawCellRect(leftEmpty : Bool, topEmpty: Bool, rightEmpty : Bool, bottomEmpty : Bool) {
        let padding = CGFloat(10)
    
        
        
        //greyBox.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.10).CGColor
        //greyBox.layer.borderWidth = 3;
        greyBox.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.15)
        greyBox.frame.origin.x = leftEmpty ? padding : CGFloat(0)
        greyBox.frame.origin.y = topEmpty ? padding : CGFloat(0)
        greyBox.frame.size.width = rightEmpty ? (leftEmpty ? self.frame.size.width - 2*padding : self.frame.size.width - padding)  : self.frame.size.width
        greyBox.frame.size.height = bottomEmpty ? (topEmpty ? self.frame.size.height - 2*padding : self.frame.size.height - padding) : self.frame.size.height
        
        
        // bordered boxes (alternative look)
        /*
        let bottomBorderPadding =  3
        let rightBorderPadding =  3
        
        if (topEmpty) {
            var lineViewTop = UIView(frame: CGRectMake(0, 0, greyBox.frame.size.width, 3))
            lineViewTop.backgroundColor=UIColor.grayColor().colorWithAlphaComponent(0.35)
            greyBox.addSubview(lineViewTop)
        }
        
        if (bottomEmpty) {
            var lineViewBottom = UIView(frame: CGRectMake(0, greyBox.frame.maxY-3, greyBox.frame.size.width, 3))
            lineViewBottom.backgroundColor=UIColor.grayColor().colorWithAlphaComponent(0.35)
            greyBox.addSubview(lineViewBottom)
        }
        
        if (leftEmpty) {
            var lineViewLeft = UIView(frame: CGRectMake(0, 0, 3, greyBox.frame.size.height))
            lineViewLeft.backgroundColor=UIColor.grayColor().colorWithAlphaComponent(0.35)
            greyBox.addSubview(lineViewLeft)
        }
        
        if (rightEmpty) {
            var lineViewRight = UIView(frame: CGRectMake(greyBox.frame.maxX - 3, 0, 3, greyBox.frame.size.height))
            lineViewRight.backgroundColor=UIColor.grayColor().colorWithAlphaComponent(0.35)
            greyBox.addSubview(lineViewRight)
        }
            
         */
 
        addSubview(greyBox)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        greyBox.removeFromSuperview()
    }

}
