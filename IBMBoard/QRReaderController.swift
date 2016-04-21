//
//  QRReaderController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-19.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol QRReaderControllerDelegate : NSObjectProtocol {
    
    func foundQRCodeString(code : String)
    
}

class TestController : KeyboardPresenter, QRReaderControllerDelegate, UITextViewDelegate {
    
    var readerView : UIView!
    var codeStrings = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reader = QRReaderController()
        reader.delegate = self
        self.addChildViewController(reader)
        reader.didMoveToParentViewController(self)
        readerView = reader.view
        self.view.addSubview(readerView)
    }
    
    func foundQRCodeString(code: String) {
        (self.view.viewWithTag(3) as! UITextView).text = code
        if !codeStrings.contains(code) {
            codeStrings.insert(code)
            QRCoder(encodedString: code).getEncodedCard() { (card) in
                self.codeStrings.remove(code)
                if UIApplication.sharedApplication().applicationState != .Active {
                    return
                }
                
                if card!.type == .Video {
                    UIApplication.sharedApplication().openURL(card!.videoURL!)
                    
                } else if card!.type == .NewsArticle {
                    UIApplication.sharedApplication().openURL(card!.articleURL!)
                    
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        readerView.frame.size.width = 300
        readerView.frame.size.height = 300

        readerView.center.x = self.view.frame.size.width / 2
        readerView.center.y = self.view.frame.size.height / 2 + 100
    }
    
    func textViewDidChange(textView: UITextView) {
        (self.view.viewWithTag(2) as! UIImageView).image = textView.text!.encodedQRImage()
        
    }
    
}

class QRReaderController : DefaultViewController {
    
    weak var delegate : QRReaderControllerDelegate?
    
    var captureSession : AVCaptureSession!
    var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    var qrCodeFrameView : UIView!
    
    override func viewDidLoad() {
        self.lockToLandscape()
        
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
        videoPreviewLayer?.frame = self.view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.mainAccentGreen().CGColor
        qrCodeFrameView?.layer.borderWidth = 2.0
        self.view.addSubview(qrCodeFrameView!)
        self.view.bringSubviewToFront(qrCodeFrameView!)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if videoPreviewLayer != nil {
            videoPreviewLayer.frame = self.view.layer.bounds
        }
        
    }

}

extension QRReaderController : AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
            
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if metadataObj.stringValue != nil {
                if delegate != nil {
                    delegate!.foundQRCodeString(metadataObj.stringValue)
                }
                
            }
        }
    }
    
}