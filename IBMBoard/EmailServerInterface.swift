//
//  EmailServerInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-01.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension ServerInterface {
    
    static func sendVerificationEmailToAccount(account : Account) {
        
        let verificationEmailText = "Welcome to IBM Board!<br>To complete your account registration, please enter this verification code in the page that is prompting for it.<br><br>Verification Code: <b>\(account.verificationCode)</b><br><br>Please do not reply to this email."
        
        let session = MCOSMTPSession()
        session.hostname = defaultEmailServer
        session.port = 465
        session.username = defaultEmailSender
        session.password = defaultEmailPassword
        
        session.connectionType = .TLS
        
        let builder = MCOMessageBuilder()
        builder.header.from = MCOAddress(displayName: nil, mailbox: defaultEmailSender)
        builder.header.to = [ MCOAddress(mailbox: account.email) ]
        builder.header.subject = "IBM Board Verification Email"
        builder.htmlBody = verificationEmailText
        
        let operation = session.sendOperationWithData(builder.data())
        operation.start { (error) in
            if error != nil {
                print("Error email could not be sent: \(error)")
                
            } else {
                print("Email was sent successfully!")
                
            }
        }
        
    }
    
}