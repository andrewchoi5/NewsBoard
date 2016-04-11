//
//  ProgressControl.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-30.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ProgressControl : UIView {
    @IBInspectable var stages : UInt = 3 {
        didSet {
            commonInit()
        }
    }
    @IBInspectable var selectedStage : UInt = 1 {
        didSet {
            commonInit()
        }
    }
    
    @IBInspectable var lineColor : UIColor = UIColor.grayColor() {
        didSet {
            commonInit()
        }
    }
    @IBInspectable var deselectedStageColor : UIColor = UIColor.grayColor() {
        didSet {
            commonInit()
        }
    }
    @IBInspectable var selectedStageColor : UIColor = UIColor.whiteColor() {
        didSet {
            commonInit()
        }
    }
    
    let selectedOuterToInnerCircleRatio   : CGFloat = 11.0  /  31.0
    let deselectedOuterToInnerCircleRatio : CGFloat =  7.0  /  19.0
    let deselectedToSelectedRatio         : CGFloat =  7.0  /  11.0
    
    var viewArray = [ UIView ]()
    
    func commonInit() {
        for view in viewArray {
            view.removeFromSuperview()
        }
        viewArray = [ UIView ]()

        for stage in 1...stages {
            
            let circle = stage == selectedStage ? makeSelectedCircle() : makeDeselectedCircle()
            let line = makeLine()
            
            viewArray.append(circle)
            self.addSubview(circle)
            
            if stage < stages {
                viewArray.append(line)
                self.addSubview(line)
                
            }
        }
    }
    
    func makeLine() -> UIView {
        let line = UIView()
        
        let selectedOuterCircleDiameter = self.frame.height
        let deselectedOuterCircleDiameter = deselectedToSelectedRatio * self.frame.height
        
        let lineWidth = (self.frame.width - CGFloat(stages - 1) * deselectedOuterCircleDiameter - selectedOuterCircleDiameter) / CGFloat(stages - 1)
        
        line.frame = CGRectMake(0,0,lineWidth,1.0)
        line.backgroundColor = lineColor
        return line
    }
    
    func makeSelectedCircle() -> UIView {
        
        let selectedOuterCircleDiameter = self.frame.height
        let selectedInnerCircleDiameter = selectedOuterCircleDiameter * selectedOuterToInnerCircleRatio
        
        let outerCircle = UIView()
        outerCircle.frame = CGRectMake(0,0,selectedOuterCircleDiameter,selectedOuterCircleDiameter)
        outerCircle.layer.cornerRadius = outerCircle.frame.width / 2
        outerCircle.layer.borderWidth = 1.0
        outerCircle.layer.borderColor = selectedStageColor.CGColor
        outerCircle.backgroundColor = UIColor.clearColor()
        
        let innerCircle = UIView()
        innerCircle.frame = CGRectMake(0,0,selectedInnerCircleDiameter,selectedInnerCircleDiameter)
        innerCircle.layer.cornerRadius = innerCircle.frame.width / 2
        innerCircle.center = outerCircle.center
        innerCircle.backgroundColor = selectedStageColor
        outerCircle.addSubview(innerCircle)
        
        return outerCircle
        
    }
    
    func makeDeselectedCircle() -> UIView {
        
        let deselectedOuterCircleDiameter = deselectedToSelectedRatio * self.frame.height
        let deselectedInnerCircleDiameter = deselectedOuterCircleDiameter * deselectedOuterToInnerCircleRatio
        
        let outerCircle = UIView()
        outerCircle.frame = CGRectMake(0,0,deselectedOuterCircleDiameter,deselectedOuterCircleDiameter)
        outerCircle.layer.cornerRadius = outerCircle.frame.width / 2
        outerCircle.layer.borderWidth = 1.0
        outerCircle.layer.borderColor = deselectedStageColor.CGColor
        outerCircle.backgroundColor = UIColor.clearColor()
        
        let innerCircle = UIView()
        innerCircle.frame = CGRectMake(0,0,deselectedInnerCircleDiameter,deselectedInnerCircleDiameter)
        innerCircle.layer.cornerRadius = innerCircle.frame.width / 2
        innerCircle.center = outerCircle.center
        innerCircle.backgroundColor = UIColor(white: 1.0, alpha: 0.75)
        outerCircle.addSubview(innerCircle)
        
        return outerCircle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var xAdded : CGFloat = 0.0
        
        for view in viewArray {
            view.frame.origin.y = (self.frame.height - view.frame.size.height) / 2
            view.frame.origin.x = xAdded
            xAdded += view.frame.size.width
            
        }
    }
    
}