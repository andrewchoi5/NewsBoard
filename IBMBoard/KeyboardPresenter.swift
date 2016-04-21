//
//  KeyboardPresenter.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-12.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class KeyboardPresenter : DefaultViewController {
    
    private var tapRecognizer = UITapGestureRecognizer()
    private var keyBoardShowing = false
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardPresenter.didReceivePresentingKeyboardNotification), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardPresenter.didReceiveDismissingKeyboardNotification), name: UIKeyboardWillHideNotification, object: nil)
        
        addTapRecognizer()
    }
    
    private func addTapRecognizer() {
        tapRecognizer.addTarget(self, action: #selector(KeyboardPresenter.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    private func disableTapRecognizer() {
        tapRecognizer.enabled = false
    }
    
    private func enableTapRecognizer() {
        tapRecognizer.enabled = true
    }
    
    @objc private func dismissKeyboard() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, forEvent:nil)
        self.disableTapRecognizer()
    }
    
    @objc private func didReceivePresentingKeyboardNotification(notification : NSNotification) {
        
        if keyBoardShowing {
            return
        }
        
        keyBoardShowing = true
        let frame = (notification.userInfo![ UIKeyboardFrameEndUserInfoKey ] as! NSValue).CGRectValue()
        self.enableTapRecognizer()
        didPresentKeyboardWithFrame(frame)
    }
    
    @objc private func didReceiveDismissingKeyboardNotification(notification : NSNotification) {
        if !keyBoardShowing {
            return
        }
        
        keyBoardShowing = false
        self.disableTapRecognizer()
        didDismissKeyboard()
        
    }
    
    func didPresentKeyboardWithFrame(frame: CGRect) {
        
    }
    
    func didDismissKeyboard() {
        
    }
    
}