//
//  CalendarViewController + FSCalendar.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import FSCalendar
import SwiftHoliday

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // MARK: Delegate e DataSource

    func calendar(_: FSCalendar, didSelect _: Date, at _: FSCalendarMonthPosition) {
        self.getDataFromCoreDataAndReloadViews()
    }

    func calendar(_: FSCalendar, shouldSelect date: Date, at _: FSCalendarMonthPosition) -> Bool {
        return self.isThisDaySelectable(date)
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange _: CGRect, animated _: Bool) {
        if self.calendarView.scope == .month {
            self.calendarViewHeightConstraint.constant = 350
        } else {
            self.calendarViewHeightConstraint.constant = 127
        }
        view.layoutIfNeeded()
    }

    func minimumDate(for _calendar: FSCalendar) -> Date {
        return Constant.startingDateBdC
    }

    func maximumDate(for _calendar: FSCalendar) -> Date {
        if self.calendarView.scope == .month && Date.now.getDayNumberOfWeek() == 1 { // Sunday
            
            return Date().dayAfter
        } else if self.calendarView.scope == .month && Date.now.getDayNumberOfWeek() == 7 {
            
            return Date().twoDayAfter
        } // Saturday
        return Date.now
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {

        if calendar.scope == .week {
            let mondayOfThisWeek = calendar.currentPage.getSpecificDayOfThisWeek(2)
            calendar.select(self.safeSelectDate(mondayOfThisWeek, isForward: true))
            self.getDataFromCoreDataAndReloadViews()

        } else if calendar.scope == .month {

            let startOfTheMonth = calendar.currentPage.getStartOfMonth()
            calendar.select(self.safeSelectDate(startOfTheMonth, isForward: true))
            self.getDataFromCoreDataAndReloadViews()
        }
    }

    // MARK: Appearance Delegate

    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if LocalDate(date: calendar.today ?? .now) == LocalDate(date: date) {
            return Theme.FSCalendarStandardTodayColor
        }
        return Theme.FSCalendarStandardSelectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateIsToday = LocalDate(date: Date()) == LocalDate(date: date)
        
        if !self.isThisDaySelectable(date) || date > calendar.maximumDate || date < calendar.minimumDate {
            return dateIsToday ? Theme.customLightRed : .lightGray
            
        } else if dateIsToday {
            return Theme.FSCalendarStandardTodayColor
        }
        return Theme.avatarBlack
    }

    // MARK: Utils

    func addCalendarGestureRecognizer() {
        let swipeGestureUpCalendar = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureUpCalendar.direction = .up
        self.calendarView.addGestureRecognizer(swipeGestureUpCalendar)

        let swipeGestureUpBottomView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureUpBottomView.direction = .up
        self.bottomCalendarHandleView.addGestureRecognizer(swipeGestureUpBottomView)

        let swipeGestureDownCalendar = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureDownCalendar.direction = .down
        self.calendarView.addGestureRecognizer(swipeGestureDownCalendar)

        let swipeGestureDownBottomView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureDownBottomView.direction = .down
        self.bottomCalendarHandleView.addGestureRecognizer(swipeGestureDownBottomView)
    }

    // The animation and the chande of constraints are performed in the delagate method: boundingRectWillChange
    func handleWeeklyToMonthlyCalendar() {
        if self.calendarView.scope == .week {
            self.calendarView.setScope(.month, animated: true)
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
    }

    func handleMonthlyToWeeklyCalendar() {
        if self.calendarView.scope == .month {
            self.calendarView.setScope(.week, animated: true)
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
    }

    /// Reload CalendarView because today is broken!
    func updateCalendarIfNeeded() {
        if Date.tomorrow.days(from: self.calendarView.maximumDate) > 0 {
            self.calendarView.today = Date.now
            self.calendarView.reloadData()
        }
    }
    
    func safeSelectDate(_ startingDate: Date, isForward: Bool = false) -> Date {
        
        if self.isThisDaySelectable(startingDate) { return startingDate }
        var date = startingDate
        repeat {
            date = isForward ? date.dayAfter : date.dayBefore
        } while(!self.isThisDaySelectable(date))
        return date
    }

    // MARK: Design Calendar

    func setUpCalendarAppearance() {
        self.calendarView.locale = Locale(identifier: "it")
        self.calendarView.scope = .week // Needed to show the weekly at start! (BUG IN THE SYSTEM)
        self.calendarView.placeholderType = .none
        self.calendarView.select(self.safeSelectDate(Date()))
        // Appearance
        self.calendarView.appearance.caseOptions = .headerUsesCapitalized
        self.calendarView.appearance.titleFont = .boldSystemFont(ofSize: 15)
        self.calendarView.appearance.weekdayFont = .systemFont(ofSize: 17, weight: .light)
        self.calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 19)
        self.calendarView.appearance.titleWeekendColor = .lightGray
        self.calendarView.appearance.todayColor = .clear
        self.calendarView.appearance.titleDefaultColor = Theme.avatarBlack
        self.calendarView.appearance.titleTodayColor = Theme.FSCalendarStandardTodayColor
        self.calendarView.appearance.headerTitleColor = Theme.FSCalendarStandardSelectionColor
        self.calendarView.appearance.weekdayTextColor = .black
    }
}
