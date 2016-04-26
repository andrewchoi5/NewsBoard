//
//  DateSelectorController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-25.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

protocol DateSelectorDelegate {
    func didPressNextDayButton()
    func didPressPreviousDayButton()
    
}

enum DateSelectorButtonState {
    case Unknown
    case Focussed
    case Faded
    case Hidden
    
}

class DateSelectorController : UIViewController {
    private var buttonState = DateSelectorButtonState.Unknown
    private var leftButton = UIButton(type: .System)
    private var rightButton = UIButton(type: .System)
    
    private var buttonVisibilityTimer : NSTimer!

    private var delayFading = false
    
    let buttonVisibilityTick = 2.0
    
    var delegate : DateSelectorDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonVisibilityTimer = NSTimer.scheduledTimerWithTimeInterval(buttonVisibilityTick, target: self, selector: #selector(DateSelectorController.enterNextAnimationState), userInfo: nil, repeats: true)

        self.view.userInteractionEnabled = false
        
        leftButton.setTitle("", forState: .Normal)
        leftButton.setTitle("", forState: .Focused)
        
        leftButton.titleLabel!.font = UIFont(name: "simple-line-icons", size: 30.0)!
        rightButton.titleLabel!.font = UIFont(name: "simple-line-icons", size: 30.0)!
        
        rightButton.setTitle("", forState: .Normal)
        rightButton.setTitle("", forState: .Focused)
        
        leftButton.userInteractionEnabled = true
        rightButton.userInteractionEnabled = true

        leftButton.addTarget(self, action: #selector(DateSelectorController.didPressLeftButton), forControlEvents: .PrimaryActionTriggered)
        
        rightButton.addTarget(self, action: #selector(DateSelectorController.didPressRightButton), forControlEvents: .PrimaryActionTriggered)

        self.parentViewController?.view.addSubview(leftButton)
        self.parentViewController?.view.addSubview(rightButton)
        
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let inwardXOffset = CGFloat(40.0)
        
        rightButton.sizeToFit()
        rightButton.layer.cornerRadius = rightButton.frame.size.width / 2
        rightButton.center.y = self.view.frame.height / 2
        rightButton.frame.origin.x = self.view.frame.size.width - rightButton.frame.size.width - inwardXOffset

        leftButton.sizeToFit()

        leftButton.layer.cornerRadius = leftButton.frame.size.height / 2
        leftButton.frame.origin.x = inwardXOffset
        leftButton.center.y = self.view.frame.height / 2

    }
    
    @objc private func didPressLeftButton() {
        
        delegate?.didPressPreviousDayButton()
        
    }
    
    @objc private func didPressRightButton() {
        
        delegate?.didPressNextDayButton()
        
    }
    
    @objc private func enterNextAnimationState() {
        if buttonState == .Unknown || buttonState == .Hidden || buttonState == .Focussed {
            if delayFading {
                delayFading = false
                return
            }
            
            if leftButton.focused || rightButton.focused {
                return
                
            }
            
            fadeButtons()
            buttonState = .Faded
            
        } else if buttonState == .Faded {
            hideButtons()
            buttonState = .Hidden
            
        }
    }
    
    private func fadeButtons() {
        
        leftButton.alpha = 0.5
        rightButton.alpha = 0.5
    }
    
    func focusButtons() {
        delayFading = true
        buttonState = .Focussed
        showButtons()
    }
    
    func defocusButtons() {
        buttonState = .Hidden
        hideButtons()
    }
    
    private func showButtons() {
        leftButton.alpha = 1.0
        rightButton.alpha = 1.0
        leftButton.hidden = false
        rightButton.hidden = false

    }
    
    private func hideButtons() {
        leftButton.hidden = true
        rightButton.hidden = true
        
    }
}

