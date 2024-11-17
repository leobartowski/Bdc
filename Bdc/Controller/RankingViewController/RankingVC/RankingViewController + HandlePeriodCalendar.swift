//
//  RankingViewController + HandlePeriodCollectionView.swift
//  Bdc
//
//  Created by leobartowski on 03/11/22.
//

import Foundation
import FSCalendar
import SwiftHoliday

extension RankingViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = 110
        self.containerPeriodView.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // The user cannot manually SELECT a specific date!
        return false
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // The user cannot manually DESELECT a specific date!
        return false
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.deselectAllDates()
        self.selectedAllDateOfTheWeek(calendar.currentPage)
        self.populateAttendance()
    }

    /// Uded for avoid  crash on the simulator!
    func maximumDate(for _: FSCalendar) -> Date {
        #if targetEnvironment(simulator)
            return Date.distantFuture
        #else
            return Date().getSpecificDayOfThisWeek(1) // Maximum date should be sunday of the current week!
        #endif
    }

    func minimumDate(for _: FSCalendar) -> Date {
        return Constant.startingDateBdC
    }

    // MARK: Calendar Appearance

    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let dateIsToday = LocalDate(date: calendar.today ?? .now) == LocalDate(date: date)
        if dateIsToday, date.isThisDaySelectable() {
            return Theme.FSCalendarStandardTodayColor
            
        } else if !date.isThisDaySelectable() || date > Date() {
            return .clear
        }
        return Theme.main
    }

    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if LocalDate(date: calendar.today ?? .now) == LocalDate(date: date) { // isToday
            return date.isThisDaySelectable() ? Theme.white : Theme.customLightRed
        }
        return (date > Date.now || !date.isThisDaySelectable()) ? .systemGray3 : Theme.white
    }
    
    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return (LocalDate(date: .now) == LocalDate(date: date) && !date.isThisDaySelectable())
        ? Theme.customLightRed
        : .lightGray
    }
    
    // MARK: Calendar SetUp

    func calendarSetup() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.locale = Locale(identifier: "it")
        self.calendarView.placeholderType = .none
        self.calendarView.scope = .week // Needed to show the weekly at start!
        self.calendarHeightConstraint.constant = 320 // This line has absolutly no sense but is needed for a bug of FSCalendar
        self.calendarView.allowsMultipleSelection = true
        // Appearance
        self.calendarView.appearance.caseOptions = .headerUsesCapitalized
        self.calendarView.appearance.titleFont = .boldSystemFont(ofSize: 15)
        self.calendarView.appearance.weekdayFont = .systemFont(ofSize: 17, weight: .light)
        self.calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 19)
        self.calendarView.appearance.titleWeekendColor = .systemGray3
        self.calendarView.appearance.todayColor = .clear
        self.calendarView.appearance.titleDefaultColor = Theme.avatarBlack
        self.calendarView.appearance.titleTodayColor = Theme.FSCalendarStandardTodayColor
        self.calendarView.appearance.headerTitleColor = Theme.main
        self.calendarView.appearance.weekdayTextColor = Theme.black
        self.calendarView.appearance.titleSelectionColor = Theme.white

    }

    func selectedAllDateOfTheWeek(_ date: Date) {
        self.daysCurrentPeriod = date.getAllSelectableDatesOfWeek()
        let daysCurrentPeriod = self.daysCurrentPeriod
        for day in daysCurrentPeriod where (day.getDayNumberOfWeek() != 1 && day.getDayNumberOfWeek() != 7) {
            self.calendarView.select(day)
        }
    }

    func deselectAllDates() {
        for date in calendarView.selectedDates {
            self.calendarView.deselect(date)
        }
    }
    
    /// Reload CalendarView because today is broken!
    func updateCalendarIfNeeded() {
        if Date.tomorrow.days(from: self.calendarView.maximumDate) > 0 {
            DispatchQueue.main.async {
                self.calendarView.reloadData()
                self.calendarView.today = Date()
                self.calendarView.appearance.calendar.reloadData()
            }
        }
    }
    
}
