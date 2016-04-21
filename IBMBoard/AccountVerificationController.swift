//
//  VerificationController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-04.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AccountVerificationController : KeyboardPresenter {
    @IBOutlet weak var verificationCodeText: RoundedTextBox!
    
    var accountToVerify : Account!
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    var verifying : Bool = false;
    
    @IBOutlet weak var QRViewer: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func didRequestResendOfEmail() {
        emailActivityIndicator.startAnimating()
        ServerInterface.sendVerificationEmailToAccount(accountToVerify) {
            self.emailActivityIndicator.stopAnimating()
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lockToPortrait()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input : AVCaptureDeviceInput!
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch {
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = QRViewer.layer.bounds
        QRViewer.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.mainAccentGreen().CGColor
        qrCodeFrameView?.layer.borderWidth = 2.0
        QRViewer.addSubview(qrCodeFrameView!)
        QRViewer.bringSubviewToFront(qrCodeFrameView!)
    }
    
    @IBAction func didAttemptToVerify() {
        attemptToVerify()
    }
    
    func attemptToVerify() {
        
        guard let code = verificationCodeText.text else { return }
        self.verifying = true;
        self.showLoading()
        if accountToVerify.verifyWithCode(code) {
            ServerInterface.updateAccount(accountToVerify, completion: {
                self.hideLoading()
                //dont set the verifying flag to false, otherwise the segue will be triggered multiple times with the qr scanner
                //self.verifying = false;
                self.performSegueWithIdentifier("verificationSuccessSegue", sender: self)
            })
            
        } else {
            self.verifying = false;
            verificationCodeText.showInvalid()
            errorDialogue("Your verification code is invalid")
            activityIndicator.stopAnimating()            
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
        self.view.constraintWithID("centerVerificationCodeConstraint")!.constant += 70.0
    }
    
    override func didPresentKeyboardWithFrame(frame: CGRect) {
        self.view.constraintWithID("centerVerificationCodeConstraint")!.constant -= 70.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "verificationSuccessSegue" {
            
            (segue.destinationViewController as! ProfilePictureController).accountForProfilePicture = accountToVerify
            
        }
    }

}

extension AccountVerificationController : AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                verificationCodeText.text = metadataObj.stringValue
                if (!verifying) {
                    attemptToVerify()
                }
            }
        }
    }
    
}
