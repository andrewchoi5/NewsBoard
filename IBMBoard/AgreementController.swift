//
//  AgreementController.swift
//  IBMBoard
//
//  Created by Dylan Trachsel on 2016-05-24.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import KeychainAccess

class AgreementController : DefaultViewController {
    var accountToDelete : Account!
    
    @IBAction func acceptClick(sender: RoundedButton) {
        let alert = UIAlertController(title: "Success!", message: "Your account has been successfully created.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func declineClick(sender: RoundedButton) {
        /*let keychain = Keychain(service: "com.ibm.cio.be.iphone.zamiulhaque.ibmboard")
        
        let emailID = NSUserDefaults.standardUserDefaults().stringForKey(LoginViewController.LoginUsernameKey)
        let password = try! keychain.getString(emailID!)*/
            if (accountToDelete != nil)
            {
                ServerInterface.deleteDocument(accountToDelete!, inDatabase: "accounts", completion: {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                })
            }
    }
}

