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
        self.getDataFromCoreDataAndReloadViews() // We don't save old data here but in the method shouldSelect
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date.dayNumberOfWeek() == 1 || date.dayNumberOfWeek() == 7 {
            return false
        }
        self.saveCurrentDataInCoreData()
        return true
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
        self.saveCurrentDataInCoreData()
        self.calendarView.select(calendar.currentPage.getSpecificDayOfThisWeek(2))
        self.getDataFromCoreDataAndReloadViews()
    }
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return DateFormatter.basicFormatter.date(from: "25/10/2021") ?? Date.yesterday
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date.now
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
    
    // The animation and the chande of constraints are performed in the delagate method: boundingRectWillChange
    func handleWeeklyToMonthlyCalendar() {
        if self.calendarView.scope == .week {
            self.calendarView.setScope(.month, animated: true)
        }
    }
    
    func handleMonthlyToWeeklyCalendar() {
        if self.calendarView.scope == .month {
            self.calendarView.setScope(.week, animated: true)
        }
    }
}
