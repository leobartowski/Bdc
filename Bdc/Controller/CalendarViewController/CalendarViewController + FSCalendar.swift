//
//  CalendarViewController + FSCalendar.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import FSCalendar

extension CalendarViewController:  FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // MARK: Delegate e DataSource
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.getDataFromCoreDataAndReloadViews() // We don't save old data here but in the method shouldSelect
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date.getDayNumberOfWeek() == 1 || date.getDayNumberOfWeek() == 7 {
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
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return DateFormatter.basicFormatter.date(from: "25/10/2021") ?? Date.yesterday
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date.now
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageString = DateFormatter.basicFormatter.string(from: self.calendarView.currentPage)
        // We need to check this != "01/10/2021" because if the current month is october 2021 and we change scope the app crash
        if self.calendarView.scope == .week && currentPageString != "01/10/2021" {
            self.saveCurrentDataInCoreData()
            self.calendarView.select(calendar.currentPage.getSpecificDayOfThisWeek(2))
            self.getDataFromCoreDataAndReloadViews()
            
        } else if self.calendarView.scope == .month {
            
            let getMonthAndYear = self.calendarView.currentPage.getMonthAndYearNumber()
            self.saveCurrentDataInCoreData()
            // To avoid crash if we are in October 2021 we cannot select 1 but we select 25
            getMonthAndYear.yearNumber == 2021 && getMonthAndYear.monthNumber == 10
            ? self.calendarView.select(DateFormatter.basicFormatter.date(from:"25/10/2021") ?? Date())
            : self.calendarView.select(calendar.currentPage.getStartOfMonth())
            self.getDataFromCoreDataAndReloadViews()
        }
    }
    
    // MARK: Appearance Delegate
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if DateFormatter.basicFormatter.string(from: calendar.today ?? .now) == DateFormatter.basicFormatter.string(from: date) {
            return Theme.FSCalendarStandardTodayColor
        }
        return Theme.FSCalendarStandardSelectionColor
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
        }
    }
    
    func handleMonthlyToWeeklyCalendar() {
        if self.calendarView.scope == .month {
            self.calendarView.setScope(.week, animated: true)
        }
    }
    
    func checkAndChangeWeekendSelectedDate() {
        if Date.now.getDayNumberOfWeek() == 1 { // Sunday
            self.calendarView.select(Date().twoDayBefore)
            self.calendarView.appearance.titleTodayColor = Theme.customLightRed
        } else if Date.now.getDayNumberOfWeek() == 7 { // Saturday
            self.calendarView.select(Date.yesterday)
            self.calendarView.appearance.titleTodayColor = Theme.customLightRed
        }
    }
    
    /// Reload CalendarView because today is broken!
    func updateCalendarIfNeeded() {
        if Date.tomorrow.days(from: self.calendarView.maximumDate) > 0 {
            self.calendarView.today = Date.now
            self.calendarView.reloadData()
        }
    }
    
    // MARK: Design Calendar
    func setUpCalendarAppearance() {
        
        self.calendarView.locale = Locale(identifier: "it")
        self.calendarView.scope = .week // Needed to show the weekly at start! (BUG IN THE SYSTEM)
        self.calendarView.placeholderType = .none
        self.calendarView.appearance.caseOptions = .headerUsesCapitalized
        self.calendarView.appearance.titleFont = .systemFont(ofSize: 15)
        self.calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 18)
        self.calendarView.appearance.titleWeekendColor = .lightGray
        self.calendarView.appearance.todayColor = .clear
        self.calendarView.appearance.titleTodayColor = Theme.FSCalendarStandardTodayColor
        self.calendarView.appearance.headerTitleColor = Theme.FSCalendarStandardSelectionColor
        self.calendarView.appearance.weekdayTextColor = Theme.FSCalendarStandardSelectionColor
        self.calendarView.select(Date.now)
    }
}
