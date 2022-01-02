//
//  CalendarViewController + FSCalendar.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import FSCalendar

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // MARK: Delegate e DataSource

    func calendar(_: FSCalendar, didSelect _: Date, at _: FSCalendarMonthPosition) {
        getDataFromCoreDataAndReloadViews()
    }

    func calendar(_: FSCalendar, shouldSelect date: Date, at _: FSCalendarMonthPosition) -> Bool {
        if date.getDayNumberOfWeek() == 1 || date.getDayNumberOfWeek() == 7 {
            return false
        }
        return true
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange _: CGRect, animated _: Bool) {
        if calendarView.scope == .month {
            calendarViewHeightConstraint.constant = 350
        } else {
            calendarViewHeightConstraint.constant = 127
        }
        view.layoutIfNeeded()
    }

    func minimumDate(for _calendar: FSCalendar) -> Date {
        return Constant.startingDateBdC
    }

    func maximumDate(for _calendar: FSCalendar) -> Date {
        if calendarView.scope == .month && Date.now.getDayNumberOfWeek() == 1 { // Sunday
            return Date().dayAfter
        } else if calendarView.scope == .month && Date.now.getDayNumberOfWeek() == 7 {
            return Date().twoDayAfter
        } // Saturday
        return Date.now
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageString = DateFormatter.basicFormatter.string(from: calendarView.currentPage)
        // We need to check this != "01/10/2021" because if the current month is october 2021 and we change scope the app crash
        if calendarView.scope == .week, currentPageString != "01/10/2021" {
            calendarView.select(calendar.currentPage.getSpecificDayOfThisWeek(2))
            getDataFromCoreDataAndReloadViews()

        } else if calendarView.scope == .month {
            let getMonthAndYear = calendarView.currentPage.getMonthAndYearNumber()
            // To avoid crash if we are in October 2021 we cannot select 1 but we select 25
            getMonthAndYear.yearNumber == 2021 && getMonthAndYear.monthNumber == 10
                ? calendarView.select(Constant.startingDateBdC)
                : checkAndChangeWeekendSelectedDateMonthScope()
            getDataFromCoreDataAndReloadViews()
        }
    }

    // MARK: Appearance Delegate

    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if DateFormatter.basicFormatter.string(from: calendar.today ?? .now) == DateFormatter.basicFormatter.string(from: date) {
            return Theme.FSCalendarStandardTodayColor
        }
        return Theme.FSCalendarStandardSelectionColor
    }

    // MARK: Utils

    func addCalendarGestureRecognizer() {
        let swipeGestureUpCalendar = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureUpCalendar.direction = .up
        calendarView.addGestureRecognizer(swipeGestureUpCalendar)

        let swipeGestureUpBottomView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureUpBottomView.direction = .up
        bottomCalendarHandleView.addGestureRecognizer(swipeGestureUpBottomView)

        let swipeGestureDownCalendar = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureDownCalendar.direction = .down
        calendarView.addGestureRecognizer(swipeGestureDownCalendar)

        let swipeGestureDownBottomView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureDownBottomView.direction = .down
        bottomCalendarHandleView.addGestureRecognizer(swipeGestureDownBottomView)
    }

    // The animation and the chande of constraints are performed in the delagate method: boundingRectWillChange
    func handleWeeklyToMonthlyCalendar() {
        if calendarView.scope == .week {
            calendarView.setScope(.month, animated: true)
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }

        }
    }

    func handleMonthlyToWeeklyCalendar() {
        if calendarView.scope == .month {
            calendarView.setScope(.week, animated: true)
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
            
        }
    }

    func checkAndChangeWeekendSelectedDate() {
        if Date.now.getDayNumberOfWeek() == 1 { // Sunday
            calendarView.select(Date().twoDayBefore)
            calendarView.appearance.titleTodayColor = Theme.customLightRed
        } else if Date.now.getDayNumberOfWeek() == 7 { // Saturday
            calendarView.select(Date.yesterday)
            calendarView.appearance.titleTodayColor = Theme.customLightRed
        }
    }
    
    func checkAndChangeWeekendSelectedDateMonthScope() {
        if calendarView.currentPage.getDayNumberOfWeek() != 1 && calendarView.currentPage.getDayNumberOfWeek() != 7 {
            calendarView.select(calendarView.currentPage.getStartOfMonth())
            
        } else if calendarView.currentPage.getDayNumberOfWeek() == 1 { // Sunday
            calendarView.select(calendarView.currentPage.dayAfter)
            calendarView.appearance.titleTodayColor = Theme.customLightRed
            
        } else if calendarView.currentPage.getDayNumberOfWeek() == 7 { // Saturday
            calendarView.select(calendarView.currentPage.twoDayAfter)
            calendarView.appearance.titleTodayColor = Theme.customLightRed
        }
    }


    /// Reload CalendarView because today is broken!
    func updateCalendarIfNeeded() {
        if Date.tomorrow.days(from: calendarView.maximumDate) > 0 {
            calendarView.today = Date.now
            calendarView.reloadData()
        }
    }

    // MARK: Design Calendar

    func setUpCalendarAppearance() {
        calendarView.locale = Locale(identifier: "it")
        calendarView.scope = .week // Needed to show the weekly at start! (BUG IN THE SYSTEM)
        calendarView.placeholderType = .none
        calendarView.select(Date.now)
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
}
