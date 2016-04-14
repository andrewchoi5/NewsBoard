//
//  GradientView.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-06.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView : UIView {
    
    @IBInspectable var startingColor : UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var endingColor : UIColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    init(withStartingColor startColor: UIColor, andEndingColor endColor: UIColor) {
        super.init(frame: CGRectZero)
        
        startingColor = startColor
        endingColor = endColor
    }
    
    func commonInit() {
        addGradientLayer()

    }
    
    func addGradientLayer() {
        gradientLayer.colors = [startingColor.CGColor, endingColor.CGColor]
        self.layer.insertSublayer(gradientLayer, atIndex: 0)
        
    }
    
    func reverseGradient() {
        gradientLayer.colors = gradientLayer.colors?.reverse()
        self.setNeedsLayout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.colors = [startingColor.CGColor, endingColor.CGColor]
        gradientLayer.frame = self.bounds
    }
}