//
//  CalendarController.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-03-10.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import Foundation
import UIKit

extension JTCalendarDayView {
    func toggleDot() {
        dotView.hidden = !dotView.hidden
    }
    
    func toggleCircleView() {
        circleView.hidden = !circleView.hidden
    }
    
}

protocol PostDateSelector {
    func startingDate() -> NSDate
    func didChangeStartingDate(date : NSDate)
    func didAddPostingDate(date : NSDate)
    func didRemovePostingDate(date: NSDate)
    func hasPostingDate(date: NSDate) -> Bool
}

@objc protocol ZHCalendarDelegate : JTCalendarDelegate {
    
    optional func calendar(calendar : JTCalendarManager, didLongPressDayView dayView : UIView!)

    
}

class CalendarController : UIViewController, ZHCalendarDelegate {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var scrollView: JTVerticalCalendarView!
    @IBOutlet weak var weekDayView: JTCalendarWeekDayView!
    
    let manager = JTCalendarManager()
    
    var delegate : PostDateSelector?
    
    func swipedDown() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UISwipeGestureRecognizer()
        gestureRecognizer.direction = .Down
        gestureRecognizer.addTarget(self, action: "swipedDown")
        view.addGestureRecognizer(gestureRecognizer)
        
        scrollView.manager = manager
        scrollView.manager?.delegate = self
        scrollView.manager?.settings.pageViewNumberOfWeeks = 5
        scrollView.manager?.contentView = scrollView
        scrollView.manager?.setDate(delegate?.startingDate())
        updateMonthLabelWithDate(manager.date())
        
        weekDayView.manager = scrollView.manager!
        scrollView.manager?.reload()
    }
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        let view = dayView as! JTCalendarDayView
        view.dotView.backgroundColor = UIColor(red: 0.0 / 255.0, green: 25.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
        view.circleView.backgroundColor = UIColor(red: 197.0 / 255.0, green: 213.0 / 255.0, blue: 228 / 255.0, alpha: 1.0)
        view.circleView.hidden = !NSCalendar.currentCalendar().isDate(view.date, inSameDayAsDate: delegate!.startingDate())

        view.dotView.hidden = !delegate!.hasPostingDate(view.date)
        
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        let view = dayView as! JTCalendarDayView
        if delegate!.hasPostingDate(view.date) {
            delegate?.didRemovePostingDate(view.date)
            
        } else {
            delegate?.didAddPostingDate(view.date)
            
        }
        view.toggleDot()
    }
    
    func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        return ZHCalendarDayView()
    }

    
    func updateMonthLabelWithDate(date: NSDate) {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM YYYY"
        
        monthLabel.text = formatter.stringFromDate(date)
        
    }
    
    func calendar(calendar: JTCalendarManager, didLongPressDayView dayView: UIView!) {
        let view = dayView as! JTCalendarDayView
        manager.setDate(view.date)
        delegate?.didChangeStartingDate(view.date)
        manager.reload()
        
    }
    
    func calendarDidLoadPreviousPage(calendar: JTCalendarManager) {
        
        updateMonthLabelWithDate(calendar.date())
        
    }
    
    func calendarDidLoadNextPage(calendar: JTCalendarManager) {
    
        updateMonthLabelWithDate(calendar.date())
        
    }

}