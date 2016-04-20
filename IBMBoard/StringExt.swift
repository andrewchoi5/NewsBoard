//
//  StringExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension String {
    
    func dateFromShortString() -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d-M-y"
        return formatter.dateFromString(self)!
    }
    
    func boardDateFromShortString() -> BoardDate {
        
        return BoardDate(withDate: self.dateFromShortString())
        
    }
    
    func encodedBase64String() -> String {
        guard let stringData = self.dataUsingEncoding(NSUTF8StringEncoding) else { return "" }
        return stringData.encodedBase64String()
    }
    
    func hashedString(withSalt salt: String) -> String {
        return JFBCrypt.hashPassword(self, withSalt: salt)
        
    }
    
    func decodedBase64String() -> String? {
        guard let validData = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0)) else { return nil }
        guard let validString = String(data: validData, encoding: NSUTF8StringEncoding) else { return nil }
        return validString
        
    }
    
    func encodedQRImage() -> UIImage? {
        guard let data = self.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false) else { return nil }
        guard let generator = CIFilter.getQRCodeGenerator(withData: data) else { return nil }
        guard let outputImage = generator.outputImage else { return nil }
        let transformedImage = outputImage.imageByApplyingTransform(CGAffineTransformMakeScale(7.0, 7.0))
        return UIImage(CGImage: CIContext(options:nil).createCGImage(transformedImage, fromRect: transformedImage.extent))
        
    }
}