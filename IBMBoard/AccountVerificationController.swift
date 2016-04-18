//
//  VerificationController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-04.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class AccountVerificationController : KeyboardPresenter {
    @IBOutlet weak var verificationCodeText: RoundedTextBox!
    var accountToVerify : Account!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func didAttemptToVerify() {
        
        guard let code = verificationCodeText.text else { return }
        self.showLoading()
        if accountToVerify.verifyWithCode(code) {
            ServerInterface.updateAccount(accountToVerify, completion: {
                self.hideLoading()
                self.performSegueWithIdentifier("verificationSuccessSegue", sender: self)
            })
            
        } else {
            verificationCodeText.showInvalid()
            errorDialogue("Your verification code is invalid")
            
        }
    }
    
    func errorDialogue(message : String) {
        print(message)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        
    }
    
    override func didDismissKeyboard() {
        self.view.constraintWithID("centerVerificationCodeConstraint")!.constant += 40.0
    }
    
    override func didPresentKeyboardWithFrame(frame: CGRect) {
        self.view.constraintWithID("centerVerificationCodeConstraint")!.constant -= 40.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "verificationSuccessSegue" {
            
            (segue.destinationViewController as! ProfilePictureController).accountForProfilePicture = accountToVerify
            
        }
    }

}
