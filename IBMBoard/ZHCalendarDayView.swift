//
//  ZHCalendarDayView.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-17.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

class ZHCalendarDayView : JTCalendarDayView {
    
    override func commonInit() {
        super.commonInit()
        
        let longPress = UILongPressGestureRecognizer()
        longPress.addTarget(self, action: "handleLongPress")
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
    }
    
    func handleLongPress() {
        guard let delegate = manager!.delegate else { return }
        guard let ZHDelegate = delegate as? ZHCalendarDelegate else { return }
        
        if ZHDelegate.respondsToSelector("calendar:didLongPressDayView:") {
            ZHDelegate.calendar!(self.manager!, didLongPressDayView: self)
        }
    }
    
}