//
//  RankingViewController + FSCalendar.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import FSCalendar

extension RankingViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

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

    
    // TODO: Crash on the simulator!
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date().getSpecificDayOfThisWeek(1) // Maximum date should be sunday of the current week!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return DateFormatter.basicFormatter.date(from: "25/10/2021") ?? Date.yesterday
    }
    
    // MARK: Calendar Appearance
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if DateFormatter.basicFormatter.string(from: calendar.today ?? .now) == DateFormatter.basicFormatter.string(from: date) {
            return Theme.FSCalendarStandardTodayColor
        }
        return date > Date.now ? .clear : Theme.FSCalendarStandardSelectionColor
    
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return date > Date.now ? .lightGray : .white
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date.getDayNumberOfWeek() == 1 || date.getDayNumberOfWeek() == 7 {
            if DateFormatter.basicFormatter.string(from: calendar.today ?? .now) == DateFormatter.basicFormatter.string(from: date) {
                return Theme.customLightRed
            }
        }
        return .lightGray
    }
   
    //MARK: Calendar SetUp
    func calendarSetup() {
        self.calendarView.locale = Locale(identifier: "it")
        self.calendarView.appearance.caseOptions = .headerUsesCapitalized
        self.calendarView.appearance.titleFont = .systemFont(ofSize: 15)
        self.calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 18)
        self.calendarView.scope = .week // Needed to show the weekly at start!
        self.calendarView.allowsMultipleSelection = true
        self.selectedAllDateOfTheWeek(self.calendarView.selectedDate ?? Date.now)
        self.calendarView.appearance.titleWeekendColor = .lightGray
        self.calendarView.appearance.titleTodayColor = Theme.FSCalendarStandardTodayColor
        self.calendarView.appearance.headerTitleColor = Theme.FSCalendarStandardSelectionColor
        self.calendarView.appearance.weekdayTextColor = Theme.FSCalendarStandardSelectionColor
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.deselectAllDates()
        self.selectedAllDateOfTheWeek(calendar.currentPage)
        self.populateWeeklyAttendance()
    }
    
    func selectedAllDateOfTheWeek(_ date: Date) {
        self.daysOfThisWeek = date.getAllDateOfTheWeek()
        for day in self.daysOfThisWeek {
            if day.getDayNumberOfWeek() != 1 && day.getDayNumberOfWeek() != 7 {
            self.calendarView.select(day)
            }
        }
    }
    
    func deselectAllDates() {
        for date in self.calendarView.selectedDates {
            self.calendarView.deselect(date)
        }
    }
}
