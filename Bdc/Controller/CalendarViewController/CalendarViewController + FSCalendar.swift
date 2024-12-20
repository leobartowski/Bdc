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
        return date.isThisDaySelectable()
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange _: CGRect, animated _: Bool) {
        if self.calendarView.scope == .month {
            self.calendarViewHeightConstraint.constant = 350
        } else {
            self.calendarViewHeightConstraint.constant = 127
        }
        view.layoutIfNeeded()
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Constant.startingDateBdC
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        self.calendarView.scope == .month
        ? self.safeSelectDate(Date(), isForward: (Date().getComponent(.day) == 1 && Date().isThisDaySelectable()) ? true : false )
        : Date()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        if calendar.scope == .week {
            let mondayOfThisWeek = calendar.currentPage.getSpecificDayOfThisWeek(2)
            calendar.select(self.safeSelectDate(mondayOfThisWeek, isForward: true))
            self.getDataFromCoreDataAndReloadViews()
        } else {
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
        return Theme.main
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateIsToday = LocalDate(date: Date()) == LocalDate(date: date)
        
        if !date.isThisDaySelectable() || date > calendar.maximumDate || date < calendar.minimumDate {
            return dateIsToday ? Theme.customLightRed : .systemGray3
            
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
            DispatchQueue.main.async {
                self.calendarView.reloadData()
                self.calendarView.today = Date()
                self.updateGoToTodayButton()
//                self.setUpCalendarAppearance()
            }
        }
    }
    
    func safeSelectDate(_ startingDate: Date, isForward: Bool = false) -> Date {
        if startingDate.isThisDaySelectable() { return startingDate }
        var date = startingDate
        var count = 0
        repeat {
            count += 1
            date = isForward ? date.dayAfter : date.dayBefore
        } while(!date.isThisDaySelectable() && count < 30)
        return date
    }

    // MARK: Design Calendar

    func setUpCalendarAppearance() {
        self.calendarView.locale = Locale(identifier: "it")
        self.calendarView.scope = .week // Needed to show the weekly at start! (BUG IN THE SYSTEM)
        self.calendarView.placeholderType = .none
        self.calendarView.select(self.safeSelectDate(Date(), isForward: false))
        // Appearance
        self.calendarView.appearance.caseOptions = .headerUsesCapitalized
        self.calendarView.appearance.titleFont = .boldSystemFont(ofSize: 15)
        self.calendarView.appearance.weekdayFont = .systemFont(ofSize: 17, weight: .light)
        self.calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 19)
        // Color
        self.calendarView.appearance.titleWeekendColor = .systemGray3
        self.calendarView.appearance.todayColor = .clear
        self.calendarView.appearance.titleDefaultColor = Theme.avatarBlack
        self.calendarView.appearance.titleTodayColor = Theme.FSCalendarStandardTodayColor
        self.calendarView.appearance.headerTitleColor = Theme.main
        self.calendarView.appearance.weekdayTextColor = Theme.label
        self.calendarView.appearance.titleSelectionColor = Theme.neutral
    }
}
