//
//  SignUpController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-01.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class SignUpController : UIViewController {
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    var newAccount : Account!
    
    @IBAction func didAttemptRegistration() {
        
        if confirmPasswordField.text != passwordField.text {
            errorDialogue("Passwords must match")
        }
        
        
        ServerInterface.checkIfEmailExists(withEmail: emailField.text!) { (emailExists) in
            
            if !emailExists {
                self.newAccount = Account(withEmail:self.emailField.text!, andPassword:self.passwordField.text!)
                
                ServerInterface.addAccount(withAccount: self.newAccount, completion: {
//                  
                    ServerInterface.sendVerificationEmailToAccount(self.newAccount)
                    self.performSegueWithIdentifier("signUpSuccessSegue", sender: self)
                    print("Account added")
                })
                
            } else {
                self.errorDialogue("Email already exists")
                
            }
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "signUpSuccessSegue" {
            
            (segue.destinationViewController as! AccountVerificationController).accountToVerify = newAccount
            
        }
    }
    
    func errorDialogue(message : String) {
        print(message)
    }
    
}