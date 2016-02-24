//
//  UINavigationExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    public override func shouldAutorotate() -> Bool {
        if let viewController = visibleViewController {
            if (viewController.respondsToSelector("shouldAutorotate")) {
                return viewController.shouldAutorotate()
            }
        }
        return true
    }
    
    public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if let viewController = visibleViewController {
            if (viewController.respondsToSelector("preferredInterfaceOrientationForPresentation")) {
                return viewController.preferredInterfaceOrientationForPresentation()
            }
        }
        return .Unknown
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let viewController = visibleViewController {
            if (viewController.respondsToSelector("supportedInterfaceOrientations")) {
                return viewController.supportedInterfaceOrientations()
            }
        }
        return .AllButUpsideDown
    }
}