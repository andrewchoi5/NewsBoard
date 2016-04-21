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
}
