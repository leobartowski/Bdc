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
        return Date.now.getDayNumberOfWeek() != 1 ? Date.now : Date.tomorrow

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
    
    func checkAndChangeWeekendSelectedDate() {
        if Date.now.getDayNumberOfWeek() == 1 { // Sunday
            self.calendarView.select(Date.tomorrow) // select Monday
            self.calendarView.appearance.todayColor = Theme.customLightRed
        } else if Date.now.getDayNumberOfWeek() == 7 { // Saturday
            self.calendarView.select(Date.yesterday) // select Friday
            self.calendarView.appearance.todayColor = Theme.customLightRed
        }
    }
    
    // MARK: Design Calendar
    func setUpCalendarAppearance() {
        self.calendarView.appearance.titleWeekendColor = .lightGray
        //        self.calendarView.appearance.caseOptions = .weekdayUsesUpperCase
    }
}
