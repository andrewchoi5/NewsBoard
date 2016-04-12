//
//  GridView.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-08.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GridView : UIView {
    
    @IBInspectable var rows : UInt = 3
    @IBInspectable var columns : UInt = 3
    
    @IBInspectable var crossLength : Double = 10.0
    
    @IBInspectable var gridLineColor : UIColor = UIColor.darkTextColor()
    @IBInspectable var crossColor : UIColor = UIColor.redColor()
    
    @IBInspectable var gridLineThickness : Double = 1.0
    
    func makeHorizontalLine(length : CGFloat, color: UIColor) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        line.frame.size.height = CGFloat(gridLineThickness)
        line.frame.size.width = length
        return line
    }
    
    func makeVerticalLine(length : CGFloat, color: UIColor) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        line.frame.size.height = length
        line.frame.size.width = CGFloat(gridLineThickness)
        return line
    }
    
    func makeCross(width: CGFloat, height: CGFloat, color: UIColor) -> UIView {
        let cross = UIView()
        cross.frame.size = CGSizeMake(width, height)
        
        let vertical = makeVerticalLine(height, color: color)
        vertical.center = cross.center
        cross.addSubview(vertical)
        
        let horizontal = makeHorizontalLine(width, color: color)
        horizontal.center = cross.center
        cross.addSubview(horizontal)
        
        return cross
    }
    
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        removeAllSubviews()
        
        let rowHeight = self.frame.size.height / CGFloat(rows)
        let columnWidth = self.frame.size.width / CGFloat(columns)
        
        for i in 1..<rows {
            let line = makeHorizontalLine(self.frame.size.width, color: gridLineColor)
            line.center.y = rowHeight * CGFloat(i)
//            line.frame = CGRectIntegral(line.frame)
            self.addSubview(line)
            
        }
        
        for i in 1..<columns {
            let line = makeVerticalLine(self.frame.size.height, color: gridLineColor)
            line.center.x = columnWidth * CGFloat(i)
//            line.frame = CGRectIntegral(line.frame)
            self.addSubview(line)
            
        }
        
        for i in 1..<rows {
            for j in 1..<columns {
                let cross = makeCross(CGFloat(crossLength), height: CGFloat(crossLength), color: crossColor)
                let x = columnWidth * CGFloat(j)
                let y = rowHeight * CGFloat(i)
                cross.center = CGPointMake(x,y)
//                cross.frame = CGRectIntegral(cross.frame)
                self.addSubview(cross)
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
}