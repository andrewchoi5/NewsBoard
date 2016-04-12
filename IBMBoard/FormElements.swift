//
//  FormElements.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-11.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

public func defaultFontOfSize(size: Double) -> UIFont {
    
    return UIFont(name:"Roboto", size: CGFloat(size))!
    
}

@IBDesignable class Switch : UISwitch {

    var oldThumbTintColor : UIColor?
    
    override var on: Bool {
        didSet(value) {
            if !value {
                super.thumbTintColor = offTintColor
                
            } else {
                super.thumbTintColor = oldThumbTintColor
                
            }
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var offTintColor : UIColor! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        oldThumbTintColor = self.thumbTintColor
        
    }
    
//    override func setOn(on: Bool, animated: Bool) {
//        super.setOn(on, animated: animated)
//        
//
//    }
    
}

@IBDesignable class RoundedButton : UIButton {
    @IBInspectable var highlightedColor : UIColor!
    var oldBackgroundColor : UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func didHighlight() {
        oldBackgroundColor = self.backgroundColor
        self.backgroundColor = highlightedColor
    }
    
    func didUnhighlight() {
        self.backgroundColor = oldBackgroundColor

    }
    
    func commonInit() {
        oldBackgroundColor = self.backgroundColor
        super.addTarget(self, action: #selector(RoundedButton.didHighlight), forControlEvents: .TouchDown)
        super.addTarget(self, action: #selector(RoundedButton.didUnhighlight), forControlEvents: .TouchUpInside)
        super.addTarget(self, action: #selector(RoundedButton.didUnhighlight), forControlEvents: .TouchUpOutside)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.height / 2
        
        
    }
}

@IBDesignable class RoundedTextBox : UIView {
    
    let textField = UITextField()
    
    var text : String? {
        get {
            return textField.text
        }
        set(value) {
            textField.text = value
        }
    }
    
    @IBInspectable var secureTextEntry : Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var textColor : UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderText : String = "Placeholder Text" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var insets : CGSize = CGSizeMake(10.0,10.0) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderColor : UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderSize : Double = 12.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
//    func makeBottomBorder() -> CALayer {
//        let bottomBorder = CALayer()
//        bottomBorder.borderColor = placeholderColor.CGColor
//        bottomBorder.borderWidth = CGFloat(bottomBorderHeight)
//        bottomBorder.frame = CGRectMake(-CGFloat(textIndent), self.frame.height - 7.0, self.frame.width + CGFloat(textIndent), CGFloat(bottomBorderHeight))
//        return bottomBorder
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
//        self.layer.addSublayer(makeBottomBorder())
        self.clipsToBounds = false
        self.addSubview(textField)

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRectInset(self.bounds, insets.width, insets.height)
        textField.secureTextEntry = self.secureTextEntry
        textField.textColor = textColor
        textField.tintColor = UIColor.whiteColor()
//        textField.backgroundColor = UIColor.redColor()
        self.layer.cornerRadius = self.frame.size.height / 2

        let placeholderString = NSMutableAttributedString(string: placeholderText)

        placeholderString.addAttribute(NSFontAttributeName, value: defaultFontOfSize(placeholderSize), range:NSMakeRange(0, placeholderString.length))
        placeholderString.addAttribute(NSForegroundColorAttributeName, value: placeholderColor, range: NSMakeRange(0, placeholderString.length))
        
        textField.attributedPlaceholder = placeholderString
        
    }
}