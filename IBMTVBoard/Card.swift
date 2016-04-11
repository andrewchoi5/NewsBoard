//
//  Card.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-15.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class BoardDate {
    
    private var date = NSDate()
    
    init(withDate aDate: NSDate) {
        
        date = aDate
    }
    
    func incrementByDay() {
        date = date.dateWithDayAdded()
    }
    
    func underlyingDate() -> NSDate {
        return date
    }
    
    func shortDateString() -> String {
        return date.shortDateString()
    }
    
    init() {
        
    }
    
}

extension BoardDate : Equatable {}
func ==(lhs: BoardDate, rhs: BoardDate) -> Bool {
    return lhs.shortDateString() == rhs.shortDateString()
}

extension BoardDate : Hashable {
    var hashValue : Int {
        return date.shortDateString().hashValue
        
    }
}

extension Card {
    
    func earliestAvailableDate() -> BoardDate {
        
        let dayAvailable = BoardDate()
        
        while datesAppearing.contains(dayAvailable) {
            dayAvailable.incrementByDay()
            
        }
        
        return dayAvailable
        
    }
    
}
