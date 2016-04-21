//
//  DefaultViewController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-20.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class DefaultViewController : UIViewController {
    
    private final var lockedToPortrait = true
    private final var statusBarHidden = false
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if lockedToPortrait {
            rotateToPortraitIfNeeded()
            
        } else {
            rotateToLandscapeIfNeeded()
            
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
    }
    
    private func rotateToPortraitIfNeeded() {
        if !UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
            
        }
        print("")

    }
    
    private func rotateToLandscapeIfNeeded() {
        if !UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
            
        }
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeRight.rawValue, forKey: "orientation")

        }
        
        if UIDevice.currentDevice().orientation == .LandscapeRight {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
            
        }
                
        print("")
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return  (lockedToPortrait) ?  .Portrait : .Landscape
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
        
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return (lockedToPortrait) ?  .Portrait : .LandscapeLeft
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return statusBarHidden
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
        
    }
    
    func lockToPortrait() {
        lockedToPortrait = true
        
    }
    
    func lockToLandscape() {
        lockedToPortrait = false
        
    }
    
    func hideStatusBar() {
        statusBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    func showStatusBar() {
        statusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
}