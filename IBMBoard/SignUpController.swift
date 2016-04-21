//
//  SignUpController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-01.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class SignUpController : KeyboardPresenter {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailField: RoundedTextBox!
    @IBOutlet weak var passwordField: RoundedTextBox!
    @IBOutlet weak var confirmPasswordField: RoundedTextBox!
    
    var newAccount : Account!
    
    func registerDelegates() {
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    override func didPresentKeyboardWithFrame(frame: CGRect) {
        self.view.constraintWithID("SignUpToBottomGuideConstraint")!.constant += 110.0
        self.view.setNeedsUpdateConstraints()
    }
    
    override func didDismissKeyboard() {
        self.view.constraintWithID("SignUpToBottomGuideConstraint")!.constant -= 110.0
        self.view.setNeedsUpdateConstraints()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lockToPortrait()
        
        registerDelegates()
        
        emailField.keyboardType = .EmailAddress
        emailField.autocapitalizationType = .None
        emailField.autocorrectionType = .No
        emailField.spellCheckingType = .No
        emailField.keyboardAppearance = .Dark
        
        emailField.isInvalid = true
        passwordField.isInvalid = true
        confirmPasswordField.isInvalid = true
    }
    
    @IBAction func didAttemptRegistration() {
        emailField.endEditing(true)
        passwordField.endEditing(true)
        confirmPasswordField.endEditing(true)

        emailField.text = emailField.text?.lowercaseString
        
        if emailField.isInvalid {
            emailField.showInvalid()
            return
        }
        
        // validate ibm email address
        if !isIBMEmail(emailField.text!) {
            emailField.showInvalid()
            self.errorDialogue("Please use a valid IBM Intranet email");
            return
        }
        
        if passwordField.isInvalid {
            passwordField.showInvalid()
            return
        }
        
        if confirmPasswordField.isInvalid {
            confirmPasswordField.showInvalid()
            return
        }
        
        if confirmPasswordField.text != passwordField.text {
            errorDialogue("Passwords must match")
            passwordField.showInvalid()
            confirmPasswordField.showInvalid()
            return
        }
        
        showLoading()
        ServerInterface.checkIfEmailExists(withEmail: emailField.text!) { (emailExists) in
            
            if !emailExists {
                self.newAccount = Account(withEmail:self.emailField.text!, andPassword:self.passwordField.text!)
                
                ServerInterface.addAccount(self.newAccount, completion: {
                    self.hideLoading()
                    ServerInterface.sendVerificationEmailToAccount(self.newAccount, completion: nil)
                    self.performSegueWithIdentifier("verificationSegue", sender: self)
                    print("Account added")
                })
                
            } else {
                self.hideLoading()
                self.emailField.showInvalid()
                self.errorDialogue("Email already exists")
                
            }
            
        }
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "verificationSegue" {
            
            (segue.destinationViewController as! AccountVerificationController).accountToVerify = newAccount
            
        }
    }
    
    func errorDialogue(message : String) {
        print(message)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func isIBMEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@+[A-Za-z]+.ibm.com"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
}

extension SignUpController : UITextFieldDelegate {
    
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
    
}