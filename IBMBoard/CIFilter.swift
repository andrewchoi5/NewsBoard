//
//  CIFilter.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-04-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension CIFilter {
    
    static func getQRCodeGenerator(withData data: NSData, inputCorrectionLevel level: String) -> CIFilter? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(level, forKey: "inputCorrectionLevel")
        return filter
        
    }
    
    static func getQRCodeGenerator(withData data: NSData) -> CIFilter? {
        return getQRCodeGenerator(withData: data, inputCorrectionLevel: "Q")
        
    }
    
}