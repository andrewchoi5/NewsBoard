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
    var accountToVerify : Account!
    @IBOutlet weak var verificationCodeText: RoundedTextBox!
    
    @IBAction func didAttemptToVerify() {
        
        guard let code = verificationCodeText.text else { return }
        if accountToVerify.verifyWithCode(code) {
            ServerInterface.updateAccount(withAccount: accountToVerify, completion: {
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
    
    override func didDismissKeyboard() {
        self.view.constraintWithID("centerVerificationCodeConstraint")!.constant += 40.0
    }
    
    override func didPresentKeyboardWithFrame(frame: CGRect) {
        self.view.constraintWithID("centerVerificationCodeConstraint")!.constant -= 40.0
    }

}
