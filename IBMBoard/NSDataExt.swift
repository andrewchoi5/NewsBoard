//
//  NSDataExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension NSData {
    
    func base64EncodedString() -> String {
        return self.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
}