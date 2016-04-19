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

public func defaultBoldFontOfSize(size: Double) -> UIFont {
    return UIFont(name:"Roboto-bold", size: CGFloat(size))!
    
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
    
    var secureTextEntry : Bool {
        get { return textField.secureTextEntry }
        set(value) {
            textField.secureTextEntry = value
        }
    }
    
    var autocapitalizationType : UITextAutocapitalizationType {
        get { return textField.autocapitalizationType }
        set(value) {
            textField.autocapitalizationType = value
        }
    }
    
    var autocorrectionType : UITextAutocorrectionType {
        get { return textField.autocorrectionType }
        set(value) {
            textField.autocorrectionType = value
        }
    }
    
    var spellCheckingType : UITextSpellCheckingType {
        get { return textField.spellCheckingType }
        set(value) {
            textField.spellCheckingType = value
        }
    }
    
    var keyboardType : UIKeyboardType {
        get { return textField.keyboardType }
        set(value) {
            textField.keyboardType = value
        }
    }
    
    var keyboardAppearance : UIKeyboardAppearance {
        get { return textField.keyboardAppearance }
        set(value) {
            textField.keyboardAppearance = value
        }
    }
    
    var returnKeyType : UIReturnKeyType {
        get { return textField.returnKeyType }
        set(value) {
            textField.returnKeyType = value
        }
    }
    
    @IBInspectable var enablesReturnKeyAutomatically : Bool {
        get { return textField.enablesReturnKeyAutomatically }
        set(value) {
            textField.enablesReturnKeyAutomatically = value
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
    
    @IBInspectable var textColor : UIColor = UIColor.whiteColor() {
        didSet {
//            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderText : String = "Placeholder Text" {
        didSet {
//            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var insets : CGSize = CGSizeMake(10.0,10.0) {
        didSet {
//            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderColor : UIColor = UIColor.whiteColor() {
        didSet {
//            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var placeholderSize : Double = 12.0 {
        didSet {
//            self.setNeedsDisplay()
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
//        self.addTarget(self, action: "textField", forControlEvents: .)
//        self.userInteractionEnabled = false
//        textField.userInteractionEnabled = true
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
        textField.textColor = textColor
        textField.tintColor = textColor
        textField.keyboardAppearance = .Dark
        textField.enablesReturnKeyAutomatically = false
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
    @IBInspectable var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    var border = CALayer();
    
    @IBInspectable var underline : Bool = false  {
        didSet {
            self.didSetUnderline()
        }
    }
    
    func commonInit() {
        self.keyboardAppearance = .Dark
    }
    
    func didSetUnderline() {
        if (underline) {
            let borderWidth = CGFloat(1)
            border.borderColor = UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 46.0 / 255.0, alpha: 0.3).CGColor
            border.frame = CGRectMake(20, self.frame.size.height - borderWidth, self.frame.size.width * 2, self.frame.size.height)
            border.borderWidth = borderWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        } else {
            border.removeFromSuperlayer();
        }
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
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var border = CALayer();
    
    @IBInspectable var underline : Bool = false  {
        didSet {
            self.didSetUnderline()
        }
    }

    func didSetUnderline() {
        if (underline) {
            let borderWidth = CGFloat(1)
            border.borderColor = UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 46.0 / 255.0, alpha: 0.3).CGColor
            border.frame = CGRectMake(20, self.frame.size.height - borderWidth, self.frame.size.width * 2, self.frame.size.height)
            border.borderWidth = borderWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        } else {
            border.removeFromSuperlayer();
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

@IBDesignable class FormLabel : UILabel {
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override func intrinsicContentSize() -> CGSize {
        let superContentSize = super.intrinsicContentSize()
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
}

@IBDesignable class ExpandableTextView : UITextView {
    @IBInspectable var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    @IBInspectable var numberOfLines : Int = 0
    @IBInspectable var borderWidth : Double = 0.0
    @IBInspectable var borderColor : UIColor = UIColor.redColor() // UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 46.0 / 255.0, alpha: 0.3)
    
    private var border = UIView()
    private var placeholderMode = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()

    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        commonInit()
        
    }
    
    func commonInit() {
        self.dataDetectorTypes = .None
        self.autocorrectionType = .No
        self.keyboardAppearance = .Dark
        self.enablesReturnKeyAutomatically = false
        border.backgroundColor = borderColor
        border.frame.size.height = CGFloat(borderWidth)
        self.textContainer.heightTracksTextView = true
        self.textContainerInset = padding
        self.clipsToBounds = true
        self.delegate = self
        self.addSubview(border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border.frame = CGRectMake(padding.left, self.frame.size.height - CGFloat(borderWidth), self.frame.size.width, self.frame.size.height)

    }
    
    func adjustToHeightOfText() {
        self.frame.size.height = self.sizeThatFits(self.frame.size).height

    }
}

extension ExpandableTextView : UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        adjustToHeightOfText()
        textView.setNeedsDisplay()
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if numberOfLines <= 0 {
            return true
        }
        
        if placeholderMode {
            textView.text = ""
//            textView.font
            placeholderMode = false
        }
        
        let oldText = self.text
        self.text = "\(self.text)\(text)"
        let currentNumberOfLines = Int(round(self.sizeThatFits(self.frame.size).height / textView.font!.lineHeight))
        self.text = oldText
        if currentNumberOfLines <= self.numberOfLines || text == "" {
            return true
            
        } else {
            return false
            
        }
    }
    
}