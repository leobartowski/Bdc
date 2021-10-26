//
//  CalendarViewController + FSCalendar.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import FSCalendar

extension CalendarViewController:  FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: Delegate e DataSource
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.updatePresences()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return (date.dayNumberOfWeek() == 1 || date.dayNumberOfWeek() == 7) ? false : true
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if self.calendarView.scope == .month {
            self.calendarViewHeightConstraint.constant = 350
        } else {
            self.calendarViewHeightConstraint.constant = 127
        }
        self.view.layoutIfNeeded()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.calendarView.select(calendar.currentPage.getSpecificDayOfThisWeek(2))
        self.updatePresences()
    }
    
    //    func minimumDate(for calendar: FSCalendar) -> Date {
    //        return DateFormatter.basicFormatter.date(from: "18/10/2021") ?? Date.yesterday
    //    }
    //
        func maximumDate(for calendar: FSCalendar) -> Date {
            return Date()
        }
    
    // MARK: Utils
    func addCalendarGestureRecognizer() {
        
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureUp.direction = .up
        self.calendarView.addGestureRecognizer(swipeGestureUp)
        
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureDown.direction = .down
        self.calendarView.addGestureRecognizer(swipeGestureDown)
    }
}
