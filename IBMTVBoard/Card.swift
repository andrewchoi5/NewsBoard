//
//  Card.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-15.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit

class BoardDate : NSObject {
    
    private var date = NSDate()
    
    init(withDate aDate: NSDate) {
        super.init()
        
        date = aDate
    }
    
    override var hashValue : Int {
        return date.shortDateString().hashValue
    
    }
    
    func incrementByDay() {
        date = date.dateWithDayAdded()
    }
    
    func shortDateString() -> String {
        return date.shortDateString()
    }
    
    override init() {
        super.init()
        
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
