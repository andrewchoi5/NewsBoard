//
//  LoginViewController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailID: RoundedTextBox!
    @IBOutlet weak var password: RoundedTextBox!
    @IBOutlet weak var rememberCredentials: UISwitch!
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    static var RememberCredentialsKey = "RememberCredentialsKey"
    static var LoginUsernameKey = "LoginUsernameKey"
    static var LoginPasswordKey = "LoginPasswordKey"
    
    static var LoginSuccessfulSegue = "LoginSuccessfulSegue"
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerDelegates()
        
        emailID.keyboardType = .EmailAddress
        
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
        
        self.performSegueWithIdentifier(LoginViewController.LoginSuccessfulSegue, sender: self)

        
//        ServerInterface.authenticateWithEmail(emailID.text!, andPassword: password.text!) { (result) in
//            if result == .Success {
//                self.performSegueWithIdentifier(LoginViewController.LoginSuccessfulSegue, sender: self)
//                
//            } else if result == .Unverified {
//                
//                
//            } else {
//                
//                
//            }
//
//        }
        
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
}

