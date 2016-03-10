//
//  LoginViewController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberCredentials: UISwitch!
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    static var RememberCredentialsKey = "RememberCredentialsKey"
    static var LoginUsernameKey = "LoginUsernameKey"
    static var LoginPasswordKey = "LoginPasswordKey"
    
    static var LoginSuccessfulSegue = "LoginSuccessfulSegue"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        if(emailID.hasText() && emailID.text == "zhaque@ca.ibm.com" && password.text == "123") {
            
            self.performSegueWithIdentifier(LoginViewController.LoginSuccessfulSegue, sender: self)
            
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rotateToPortraitIfNeeded()
    }
    
    func rotateToPortraitIfNeeded() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [ .Portrait ]
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
}

