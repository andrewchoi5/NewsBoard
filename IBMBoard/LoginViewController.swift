//
//  LoginViewController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class LoginViewController: KeyboardPresenter, UITextFieldDelegate {

    @IBOutlet weak var emailID: RoundedTextBox!
    @IBOutlet weak var password: RoundedTextBox!
    @IBOutlet weak var rememberCredentials: UISwitch!
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    static var RememberCredentialsKey = "RememberCredentialsKey"
    static var LoginUsernameKey = "LoginUsernameKey"
    static var LoginPasswordKey = "LoginPasswordKey"
    static var LoginSuccessfulSegue = "LoginSuccessfulSegue"
    
    var userAccount : Account!
    
    func registerDelegates() {
        emailID.delegate = self
        password.delegate = self
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == emailID.textField {
            if textField.text! == "" {
                emailID.showInvalid()
                
            } else {
                emailID.showNormal()
                
            }
            
        } else if textField == password.textField {
            if textField.text! == "" {
                password.showInvalid()
                
            } else {
                password.showNormal()
                
            }
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailID.textField {
            emailID.showFocussed()
            
        } else if textField == password.textField {
            password.showFocussed()
            
        }
    }
    
    override func didPresentKeyboardWithFrame(frame: CGRect) {
        self.view.constraintWithID("logoToEmailIDConstraint")!.constant += 70.0
        self.view.setNeedsUpdateConstraints()
    }
    
    override func didDismissKeyboard() {
        self.view.constraintWithID("logoToEmailIDConstraint")!.constant -= 70.0
        self.view.setNeedsUpdateConstraints()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerDelegates()
        
        emailID.keyboardType = .EmailAddress
        emailID.autocapitalizationType = .None
        emailID.autocorrectionType = .No
        emailID.spellCheckingType = .No
        
        rememberCredentials.on = userDefaults.boolForKey(LoginViewController.RememberCredentialsKey)
        emailID.text = userDefaults.stringForKey(LoginViewController.LoginUsernameKey)
        password.text = userDefaults.stringForKey(LoginViewController.LoginPasswordKey)

    }

    @IBAction func loginPressed() {
        
        if(rememberCredentials.on) {
            userDefaults.setBool(true, forKey: LoginViewController.RememberCredentialsKey)
            userDefaults.setObject(emailID.text, forKey: LoginViewController.LoginUsernameKey)
            userDefaults.setObject(password.text, forKey: LoginViewController.LoginPasswordKey)
            
        }
        
//        self.performSegueWithIdentifier(LoginViewController.LoginSuccessfulSegue, sender: self)

        ServerInterface.getAccountWithEmail(withEmail: emailID.text!, andPassword: password.text!) { (account) in
            
            if account == nil {
                self.emailID.showInvalid()
                self.password.showInvalid()
                return
            }
            
            self.userAccount = account!
            
            if !account!.verified {
                self.performSegueWithIdentifier("reverificationSegue", sender: self)
                return
                
            }
            
            self.performSegueWithIdentifier(LoginViewController.LoginSuccessfulSegue, sender: self)

        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rotateToPortraitIfNeeded()
    }
    
    func rotateToPortraitIfNeeded() {
        if(UIDeviceOrientationIsLandscapeOrUnknown(UIDevice.currentDevice().orientation)) {
            UIDevice.currentDevice().setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait 
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "reverificationSegue" {
            (segue.destinationViewController as! AccountVerificationController).accountToVerify = userAccount
            
        }
    }
}

