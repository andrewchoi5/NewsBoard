//
//  VerificationController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-04.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class AccountVerificationController : UIViewController {
    var accountToVerify : Account!
    
    @IBOutlet weak var verificationCodeText: UITextField!
    
    @IBAction func didAttemptToVerify() {
        
        guard let code = verificationCodeText.text else { return }
        if accountToVerify.verifyWithCode(code) {
            ServerInterface.updateAccount(withAccount: accountToVerify, completion: {
                self.performSegueWithIdentifier("verificationSuccessSegue", sender: self)
            })
            
        } else {
            errorDialogue("Your verification code is invalid")
            
        }
    }
    
    func errorDialogue(message : String) {
        print(message)
    }
    
}
