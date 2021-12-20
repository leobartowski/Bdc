//
//  RankingViewController + FSCalendar.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import FSCalendar

extension RankingViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_: FSCalendar, boundingRectWillChange _: CGRect, animated _: Bool) {
        calendarViewHeightConstraint.constant = 127
        view.layoutIfNeeded()
    }

    func calendar(_: FSCalendar, shouldSelect _: Date, at _: FSCalendarMonthPosition) -> Bool {
        // The user cannot manually select a specific date!
        return false
    }

    func calendar(_: FSCalendar, shouldDeselect _: Date, at _: FSCalendarMonthPosition) -> Bool {
        // The user cannot manually de-select a specific date!
        return false
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.deselectAllDates()
        self.selectedAllDateOfTheWeek(calendar.currentPage)
        populateWeeklyAttendance()
    }

    // TODO: Crash on the simulator!
    func maximumDate(for _: FSCalendar) -> Date {
        #if targetEnvironment(simulator)
            return Date.distantFuture
        #else
            return Date().getSpecificDayOfThisWeek(1) // Maximum date should be sunday of the current week!
        #endif
    }

    func minimumDate(for _: FSCalendar) -> Date {
        return DateFormatter.basicFormatter.date(from: "25/10/2021") ?? Date.yesterday
    }

    // MARK: Calendar Appearance

    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if DateFormatter.basicFormatter.string(from: calendar.today ?? .now) == DateFormatter.basicFormatter.string(from: date) {
            return Theme.FSCalendarStandardTodayColor
        }
        return date > Date.now ? .clear : Theme.FSCalendarStandardSelectionColor
    }

    func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return date > Date.now ? .lightGray : .white
    }

    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date.getDayNumberOfWeek() == 1 || date.getDayNumberOfWeek() == 7 {
            if DateFormatter.basicFormatter.string(from: calendar.today ?? .now) == DateFormatter.basicFormatter.string(from: date) {
                return Theme.customLightRed
            }
        }
        return .lightGray
    }

    // MARK: Calendar SetUp

    func calendarSetup() {
        calendarView.locale = Locale(identifier: "it")
        calendarView.placeholderType = .none
        calendarView.scope = .week // Needed to show the weekly at start!
        calendarView.allowsMultipleSelection = true
        self.selectedAllDateOfTheWeek(calendarView.selectedDate ?? Date.now)
        // Appearance
        calendarView.appearance.caseOptions = .headerUsesCapitalized
        calendarView.appearance.titleFont = .boldSystemFont(ofSize: 15)
        calendarView.appearance.weekdayFont = .systemFont(ofSize: 17, weight: .light)
        calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 19)
        calendarView.appearance.titleWeekendColor = .lightGray
        calendarView.appearance.todayColor = .clear
        calendarView.appearance.titleDefaultColor = Theme.avatarBlack
        calendarView.appearance.titleTodayColor = Theme.FSCalendarStandardTodayColor
        calendarView.appearance.headerTitleColor = Theme.FSCalendarStandardSelectionColor
        calendarView.appearance.weekdayTextColor = .black
    }

    func selectedAllDateOfTheWeek(_ date: Date) {
        daysOfThisWeek = date.getAllDateOfTheWeek()
        for day in daysOfThisWeek {
            if day.getDayNumberOfWeek() != 1, day.getDayNumberOfWeek() != 7 {
                calendarView.select(day)
            }
        }
    }

    func deselectAllDates() {
        for date in calendarView.selectedDates {
            calendarView.deselect(date)
        }
    }
}
