//
//  NSDateExt.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-16.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation

extension NSDate {
    
    func shortDateString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "d-M-y"
        return formatter.stringFromDate(self)
    }
    
    func mediumDateString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        return formatter.stringFromDate(self)
        
    }

    func isSameDayAs(anotherDate : NSDate) -> Bool {
        
        return NSCalendar.currentCalendar().isDate(self, inSameDayAsDate: anotherDate)
        

        
    }
    
    func isYesterday() -> Bool {
        return NSCalendar.currentCalendar().isDateInYesterday(self)
        
    }
    
    func isToday() -> Bool {
        return NSCalendar.currentCalendar().isDateInToday(self)
        
    }
    
    func isTomorrow() -> Bool {
        return NSCalendar.currentCalendar().isDateInTomorrow(self)
        
    }
    
    func dateWithDayAdded() -> NSDate {
        guard let newDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: self, options: NSCalendarOptions(rawValue: 0)) else { return NSDate() }
        return newDate
    
    }
    
    func dateWithDaySubtracted() -> NSDate {
        guard let newDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: self, options: NSCalendarOptions(rawValue: 0)) else { return NSDate() }
        return newDate
        
    }
    
}