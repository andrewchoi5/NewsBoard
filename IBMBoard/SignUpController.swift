//
//  SignUpController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-01.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class SignUpController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: RoundedTextBox!
    @IBOutlet weak var passwordField: RoundedTextBox!
    @IBOutlet weak var confirmPasswordField: RoundedTextBox!
    
    var newAccount : Account!
    
    func registerDelegates() {
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == emailField.textField {
            if textField.text! == "" {
                emailField.showInvalid()
                
            } else {
                emailField.showNormal()
                
            }
            
        } else if textField == passwordField.textField {
            if textField.text! == "" {
                passwordField.showInvalid()
                
            } else {
                passwordField.showNormal()
                
            }
            
        } else if textField == confirmPasswordField.textField {
            if textField.text! == "" {
                confirmPasswordField.showInvalid()
                
            } else {
                confirmPasswordField.showNormal()
                
            }
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailField.textField {
            emailField.showFocussed()
            
        } else if textField == passwordField.textField {
            passwordField.showFocussed()
            
        } else if textField == confirmPasswordField.textField {
            confirmPasswordField.showFocussed()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerDelegates()
        
        emailField.keyboardType = .EmailAddress
        
        emailField.isInvalid = true
        passwordField.isInvalid = true
        confirmPasswordField.isInvalid = true
    }
    
    @IBAction func didAttemptRegistration() {
        
        if emailField.isInvalid || passwordField.isInvalid || confirmPasswordField.isInvalid {
            return
        }
        
        if confirmPasswordField.text != passwordField.text {
            errorDialogue("Passwords must match")
            confirmPasswordField.showInvalid()
            return
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