//
//  LoginViewController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit
import KeychainAccess
import LocalAuthentication

class LoginViewController: KeyboardPresenter {

    @IBOutlet weak var emailID: RoundedTextBox!
    @IBOutlet weak var password: RoundedTextBox!
    @IBOutlet weak var rememberCredentials: UISwitch!
    @IBOutlet weak var qrButton: QRButton!
    @IBOutlet weak var qrLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    static var RememberCredentialsKey = "RememberCredentialsKey"
    static var LoginUsernameKey = "LoginUsernameKey"
    static var LoginSuccessfulSegue = "LoginSuccessfulSegue"
    
    var userAccount : Account!
    
    func registerDelegates() {
        emailID.delegate = self
        password.delegate = self
        
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
        
        self.lockToPortrait()
        
        registerDelegates()
        
        let keychain = Keychain(service: "com.ibm.IBMBoard")
        
        emailID.keyboardType = .EmailAddress
        emailID.autocapitalizationType = .None
        emailID.autocorrectionType = .No
        emailID.spellCheckingType = .No
        
        qrButton.setLabel(qrLabel)
        
        rememberCredentials.on = userDefaults.boolForKey(LoginViewController.RememberCredentialsKey)
        
        if rememberCredentials.on {
            emailID.text = userDefaults.stringForKey(LoginViewController.LoginUsernameKey)
            password.text = try! keychain.getString(emailID.text!)
            
            performLogin()
        }

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        emailID.showNormal()
        password.showNormal()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        
    }
    
    @IBAction func loginPressed() {
        performLogin()
    }
    
    @IBAction func touchIDloginPressed() {
        performTouchIDLogin()
    }
    
    // not working correctly
    func performTouchIDLogin() {
        
        let keychain = Keychain(service: "com.ibm.IBMBoard")
        
        let authenticationContext = LAContext()
        var error:NSError?
    
        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            print("No touchid on device")
            return
            
        }
        
        authenticationContext.evaluatePolicy(
            .DeviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Login to IBM Board",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    self.password.text = keychain[self.emailID.text!]
                        
                        ServerInterface.getAccount(withEmail: self.emailID.text!, andPassword: self.password.text!) { (account) in
                            self.hideLoading()
                            if account == nil {
                                self.emailID.showInvalid()
                                self.password.showInvalid()
                                return
                            }
                            
                            self.userAccount = account!
                            
                            if !self.userAccount.verified {
                                self.performSegueWithIdentifier("reverificationSegue", sender: self)
                                return
                                
                            }
                            
                            if !self.userAccount.hasProfilePicture() {
                                self.performSegueWithIdentifier("profilePictureSegue", sender: self)
                                return
                                
                            }
                            
                            self.performSegueWithIdentifier(LoginViewController.LoginSuccessfulSegue, sender: self)
                    }

                    
                }else {
                    
                    // Check if there is an error
                    if let error = error {
                        
                        let message = self.errorMessageForLAErrorCode(error.code)
                        print(message)
                    }
                    
                }
                
            })
    }
    
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.AppCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.AuthenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.InvalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.PasscodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.SystemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.TouchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.TouchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.UserCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.UserFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    
    func performLogin() {
        self.showLoading()
        emailID.endEditing(true)
        password.endEditing(true)
        
        emailID.text = emailID.text?.lowercaseString
        
        let keychain = Keychain(service: "com.ibm.IBMBoard")
        
        if(rememberCredentials.on) {
            userDefaults.setBool(true, forKey: LoginViewController.RememberCredentialsKey)
            userDefaults.setObject(emailID.text, forKey: LoginViewController.LoginUsernameKey)
            
            keychain[emailID.text!] = password.text
            
        } else {
            userDefaults.setBool(false, forKey: LoginViewController.RememberCredentialsKey)
            userDefaults.setObject("", forKey: LoginViewController.LoginUsernameKey)
            
            /*
            let keys = keychain.allKeys()
            for key in keys {
                do {
                    try keychain.remove(key)
                } catch let error {
                    // Error handling if needed...
                }
            }
            */
        }
        
        ServerInterface.getAccount(withEmail: self.emailID.text!, andPassword: self.password.text!) { (account) in
                    self.hideLoading()
                    if account == nil {
                        self.emailID.showInvalid()
                        self.password.showInvalid()
                        return
                    }
                    
                    self.userAccount = account!
                    
                    if !self.userAccount.verified {
                        self.performSegueWithIdentifier("reverificationSegue", sender: self)
                        return
                        
                    }
                    
                    if !self.userAccount.hasProfilePicture() {
                        self.performSegueWithIdentifier("profilePictureSegue", sender: self)
                        return
                        
                    }
                    
                    self.performSegueWithIdentifier(LoginViewController.LoginSuccessfulSegue, sender: self)
                    
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "reverificationSegue" {
            (segue.destinationViewController as! AccountVerificationController).accountToVerify = userAccount
            
        }
        
        if segue.identifier == "profilePictureSegue" {
            (segue.destinationViewController as! ProfilePictureController).accountForProfilePicture = userAccount
            
        }
        
        if segue.identifier == LoginViewController.LoginSuccessfulSegue {
            SessionInformation.currentSession.userAccount = userAccount
            
        }
    }
    
    @IBAction func unwindToLogin(segue : UIStoryboardSegue) {
        
    }
}

// ugly hack to allow qr button label to appear pressed when clicked
class QRButton : UIButton {
    
    var QRlabel : UILabel!
    var QRlabelColor : UIColor!
    
    func setLabel(label : UILabel) {
        self.QRlabel = label;
        self.QRlabelColor = label.textColor;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let touch = touches.first {
            _ = touch.locationInView(self)
            QRlabel.textColor = QRlabelColor.colorWithAlphaComponent(0.20);
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if let touch = touches.first {
            _ = touch.locationInView(self)
            QRlabel.textColor = QRlabelColor
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?){
        super.touchesCancelled(touches, withEvent: event)
        if let touch = touches!.first {
            _ = touch.locationInView(self)
            QRlabel.textColor = QRlabelColor
        }
    }
}


extension LoginViewController : UITextFieldDelegate {

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

}