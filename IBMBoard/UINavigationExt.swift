//
//  UINavigationExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class NavigationDelegate : NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        
        
    }

    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        
        print("")
        
        return .All
    }

    
}

class NavigationController : UINavigationController {
    
    weak var navDelegate = NavigationDelegate()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = navDelegate
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = navDelegate
        
    }
    
}

extension UIAlertController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    public override func shouldAutorotate() -> Bool {
        return true
    }
}


extension UINavigationController {
    // NOTE: By default, UINavigationController relies on it's own implementation of these methods rather than
    // invoking the methods of the currently visible view controller (or the view controller on top of the stack).
    // The code below was made to remedy that.
    
    public override func shouldAutorotate() -> Bool {
        if let viewController = topViewController {
            if viewController.respondsToSelector(#selector(UIViewController.shouldAutorotate)) {
                return viewController.shouldAutorotate()
            }
        }
        return true
    }
    
    public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if let viewController = topViewController {
            if viewController.respondsToSelector(#selector(UIViewController.preferredInterfaceOrientationForPresentation)) {
                return viewController.preferredInterfaceOrientationForPresentation()
            }
        }
        return .Unknown
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let viewController = topViewController {
            if viewController.respondsToSelector(#selector(UIViewController.supportedInterfaceOrientations)) {
                return viewController.supportedInterfaceOrientations()
            }
        }
        return .AllButUpsideDown
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let viewController = topViewController {
            if viewController.respondsToSelector(#selector(UIViewController.preferredStatusBarStyle)) {
                return viewController.preferredStatusBarStyle()
            }
        }
        return .Default
    }
}