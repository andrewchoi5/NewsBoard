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
    weak var delegate : UITextFieldDelegate?
    var isInvalid = false
    @IBInspectable var keyboardType : UIKeyboardType = .Default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
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
    
    func showInvalid() {
        isInvalid = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 253.0 / 255.0, green: 103.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0).CGColor
    }
    
    func showFocussed() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 127.0 / 255.0, green: 132.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0).CGColor
    }
    
    func showNormal() {
        isInvalid = false
        self.layer.borderColor = nil
        self.layer.borderWidth = 0.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.delegate = self
        textField.frame = CGRectInset(self.bounds, insets.width, insets.height)
        textField.secureTextEntry = self.secureTextEntry
        textField.textColor = textColor
        textField.tintColor = textColor
        self.layer.cornerRadius = self.frame.size.height / 2
        
        let placeholderString = NSMutableAttributedString(string: placeholderText)

        placeholderString.addAttribute(NSFontAttributeName, value: defaultFontOfSize(placeholderSize), range:NSMakeRange(0, placeholderString.length))
        placeholderString.addAttribute(NSForegroundColorAttributeName, value: placeholderColor, range: NSMakeRange(0, placeholderString.length))
        
        textField.attributedPlaceholder = placeholderString
        
    }
}

extension RoundedTextBox : UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        guard let delegateObject = delegate else { return true }
        guard let method = delegateObject.textFieldShouldBeginEditing else { return true }
        
        return method(textField)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        guard let delegateObject = delegate else { return }
        guard let method = delegateObject.textFieldDidBeginEditing else { return }

        method(textField)

    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        guard let delegateObject = delegate else { return true }
        guard let method = delegateObject.textFieldShouldEndEditing else { return true }

        return method(textField)

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let delegateObject = delegate else { return }
        guard let method = delegateObject.textFieldDidEndEditing else { return }
        
        method(textField)

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let delegateObject = delegate else { return true }
        guard let method = delegateObject.textField else { return true }

        return method(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        guard let delegateObject = delegate else { return true }
        guard let method = delegateObject.textFieldShouldBeginEditing else { return true }

        return method(textField)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let delegateObject = delegate else { return true }
        guard let method = delegateObject.textFieldShouldBeginEditing else { return true }
        
        return method(textField)

    }
}

@IBDesignable class FormTextField : UITextField {
    @IBInspectable var highlightedColor : UIColor!
    var oldBackgroundColor : UIColor!
    var gradientBackgroundStartColor = UIColor(red: 193.0 / 255.0, green: 225.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    var gradientBackgroundEndColor = UIColor(red: 249.0 / 255.0, green: 251.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    
    var backgroundLayer : CAGradientLayer!
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);

    func addGradientBackground() {
        backgroundLayer = CAGradientLayer()
        backgroundLayer.colors = [gradientBackgroundStartColor.CGColor, gradientBackgroundEndColor.CGColor]
        backgroundLayer.startPoint = CGPointMake(0, 0.5);
        backgroundLayer.endPoint = CGPointMake(1.0, 0.5);
        self.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(0.5)
        border.borderColor = UIColor(red: 127.0 / 255.0, green: 132.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0).CGColor
        border.frame = CGRectMake(20, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
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
        addGradientBackground()
        reverseBackgroundGradient()
        useUnderline()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = self.bounds
        
    }
    
    func reverseBackgroundGradient() {
        backgroundLayer.colors = backgroundLayer.colors?.reverse()
        self.setNeedsLayout()
        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

@IBDesignable class FormButton : UIButton {
    @IBInspectable var highlightedColor : UIColor!
    var oldBackgroundColor : UIColor!
    var gradientBackgroundStartColor = UIColor(red: 193.0 / 255.0, green: 225.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    var gradientBackgroundEndColor = UIColor(red: 249.0 / 255.0, green: 251.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    
    var backgroundLayer : CAGradientLayer!
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
    
    func addGradientBackground() {
        backgroundLayer = CAGradientLayer()
        backgroundLayer.colors = [gradientBackgroundStartColor.CGColor, gradientBackgroundEndColor.CGColor]
        backgroundLayer.startPoint = CGPointMake(0, 0.5);
        backgroundLayer.endPoint = CGPointMake(1.0, 0.5);
        self.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(0.5)
        border.borderColor = UIColor(red: 127.0 / 255.0, green: 132.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0).CGColor
        border.frame = CGRectMake(20, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
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
        addGradientBackground()
        reverseBackgroundGradient()
        useUnderline()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = self.bounds
        
    }
    
    func reverseBackgroundGradient() {
        backgroundLayer.colors = backgroundLayer.colors?.reverse()
        self.setNeedsLayout()
        
    }
}


@IBDesignable class FormTextView: UITextView
{
    var gradientBackgroundStartColor = UIColor(red: 193.0 / 255.0, green: 225.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    var gradientBackgroundEndColor = UIColor(red: 249.0 / 255.0, green: 251.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    
    var backgroundLayer : CAGradientLayer!
    let padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20);
    
    func addGradientBackground() {
        backgroundLayer = CAGradientLayer()
        backgroundLayer.colors = [gradientBackgroundStartColor.CGColor, gradientBackgroundEndColor.CGColor]
        backgroundLayer.startPoint = CGPointMake(0, 0.5);
        backgroundLayer.endPoint = CGPointMake(1.0, 0.5);
        self.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer : textContainer)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = self.bounds
    }
    
    func reverseBackgroundGradient() {
        backgroundLayer.colors = backgroundLayer.colors?.reverse()
        self.setNeedsLayout()
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit() {
        addGradientBackground()
        reverseBackgroundGradient()
        self.textContainerInset = padding
    }
}
