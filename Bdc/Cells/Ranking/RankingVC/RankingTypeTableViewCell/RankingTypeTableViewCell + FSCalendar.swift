//
//  RankingTypeTableViewCell + FSCalendar.swift
//  Bdc
//
//  Created by leobartowski on 29/12/21.
//

import UIKit
import FSCalendar

extension RankingTypeTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = 110
        self.contentView.layoutIfNeeded()
        self.containerView.layoutIfNeeded()
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
        self.rankingViewController?.populateAttendance()
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
        return Constant.startingDateBdC
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
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        calendarView.locale = Locale(identifier: "it")
        calendarView.placeholderType = .none
        calendarView.scope = .week // Needed to show the weekly at start!
        calendarHeightConstraint.constant = 320 // This line has absolutly no sense but is needed for a bug of FSCalendar
        calendarView.allowsMultipleSelection = true
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
        self.rankingViewController?.daysCurrentPeriod = date.getAllDateOfTheWeek()
        for day in self.rankingViewController?.daysCurrentPeriod ?? [] {
            if day.getDayNumberOfWeek() != 1, day.getDayNumberOfWeek() != 7 {
                self.calendarView.select(day)
            }
        }
    }

    func deselectAllDates() {
        for date in calendarView.selectedDates {
            self.calendarView.deselect(date)
        }
    }
}

