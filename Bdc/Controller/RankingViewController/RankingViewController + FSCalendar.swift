//
//  RankingViewController + FSCalendar.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import FSCalendar

extension RankingViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarViewHeightConstraint.constant = 127
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // The user cannot manually select a specific date!
        return false
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // The user cannot manually de-select a specific date!
        return false
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.deselectAllDates()
        self.selectedAllDateOfTheWeek(calendar.currentPage)
    }
    
    func selectedAllDateOfTheWeek(_ date: Date) {
        for day in date.getAllDateOfTheWeek() {
            self.calendarView.select(day)
        }
    }
    
    func deselectAllDates() {
        for date in self.calendarView.selectedDates {
            self.calendarView.deselect(date)
        }
    }

}
