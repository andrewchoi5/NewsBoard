//
//  EmailServerInterface.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-01.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension ServerInterface {
    
    static func sendVerificationEmailToAccount(account : Account, completion: ((Void) -> Void)?) {
        NSLog("try1")
        let ses = MCOSMTPSession()
        NSLog("beginning of sending email")
        let session = MCOSMTPSession()
        session.hostname = defaultEmailServer
        session.port = 465
        session.username = defaultEmailSender
        session.password = defaultEmailPassword
        
        session.connectionType = .TLS
        NSLog("setting session settings")
        guard let QRCodeImage = account.verificationCode.encodedQRImage() else { return }
        guard let imageData = UIImagePNGRepresentation(QRCodeImage) else { return }
        NSLog("finished setting qrcode")
        let attachment = MCOAttachment(data: imageData, filename: "QRCodeImage")
        attachment.mimeType = "image/png"
        attachment.contentID = "QRCode123456"        
        NSLog("finished attatchements")
        let verificationEmailText = "Welcome to IBM Board!<br>To complete your account registration, please enter this verification code in the page that is prompting for it.<br><br>Verification Code: <b>\(account.verificationCode)</b><br><br>Please do not reply to this email.<br><br><img src='cid:\(attachment.contentID)' alt=''>"
        NSLog("before builder")
        let builder = MCOMessageBuilder()
        builder.header.from = MCOAddress(displayName: nil, mailbox: defaultEmailSender)
        builder.header.to = [ MCOAddress(mailbox: account.email) ]
        builder.header.subject = "IBM Board Verification Email"
        builder.addRelatedAttachment(attachment)
        builder.htmlBody = verificationEmailText
        NSLog("after builder")
        let operation = session.sendOperationWithData(builder.data())
        operation.start { (error) in
            if error != nil {
                NSLog("Error email could not be sent: \(error)")
            } else {
                NSLog("Email was sent successfully!")
            }
            guard let handler = completion else { return }
            handler()
        }
        
        NSLog("end of sending email")
        
    }
    
}