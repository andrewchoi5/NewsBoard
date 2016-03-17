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
    
}