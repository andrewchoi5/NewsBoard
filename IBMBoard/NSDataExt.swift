//
//  NSDataExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension NSData {
    
    func encodedBase64String() -> String {
        return self.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
    }
    
    func encodedBase64Data() -> NSData {
        return self.base64EncodedDataWithOptions(.Encoding64CharacterLineLength)
        
    }
    
}