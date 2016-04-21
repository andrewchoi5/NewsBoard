//
//  ErrorDialog.swift
//  IBMBoard
//
//  Created by Andrew Frolkin on 2016-04-21.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class Dialog {
    
    static func showError(message : String, viewController : UIViewController) {
        print("ERROR: \(message)")
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showMessage(title: String, message : String, viewController : UIViewController) {
        print("MESSAGE: \(message)")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    static func showError(message: String) {
        guard let topViewController = topViewControllerInWindow() else { return }
        Dialog.showError(message, viewController: topViewController)
        
    }
    
    static func showMessage(title: String, message : String) {
        guard let topViewController = topViewControllerInWindow() else { return }
        Dialog.showMessage(title, message: message, viewController: topViewController)

    }
    
    static func topViewControllerInWindow() -> UIViewController? {
        guard let rootViewController = rootViewControllerInWindow() else { return nil }
        
        if let navigationController = rootViewController as? UINavigationController {
            return topVisibleControllerInNavigationController(navigationController)
            
        }
        
        return topVisibleControllerOnViewController(rootViewController)
    }
    
    static func rootViewControllerInWindow() -> UIViewController? {
        return UIApplication.sharedApplication().keyWindow?.rootViewController
        
    }
    
    static func topVisibleControllerOnViewController(viewController : UIViewController) -> UIViewController? {
        if let presentedViewController = viewController.presentedViewController {
            topVisibleControllerOnViewController(presentedViewController)
            
        } else {
            return viewController

        }
        return nil
    }
    
    static func topVisibleControllerInNavigationController(controller: UINavigationController) -> UIViewController? {
        if let topViewController = controller.visibleViewController {
            if topViewController is NavigationController {
                return topVisibleControllerInNavigationController(topViewController as! UINavigationController)
                
            } else {
                return topViewController
                
            }
        }
        return nil
    }
}
