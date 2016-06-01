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
    @IBAction func acceptClick(sender: RoundedButton) {
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    @IBAction func declineClick(sender: RoundedButton) {
        let keychain = Keychain(service: "com.ibm.cio.be.iphone.zamiulhaque.ibmboard")
        
        let emailID = NSUserDefaults.standardUserDefaults().stringForKey(LoginViewController.LoginUsernameKey)
        let password = try! keychain.getString(emailID!)
        
        ServerInterface.getAccount(withEmail: emailID!, andPassword: password!) { (account)
            in
            if (account != nil)
            {
                ServerInterface.deleteDocument(account!, inDatabase: "accounts", completion: {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                })
            }
        }
    }
}

