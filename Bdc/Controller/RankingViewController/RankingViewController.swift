//
//  RankingViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import UIKit
import SpreadsheetView
import FSCalendar

class RankingViewController: UIViewController {

    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    var weeklyAttendance = Utility.personsWeeklyAttendance
    let header = ["Nome", "Presenze", "Ammonizioni"]
    var daysOfThisWeek = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetUp()
        self.populateWeeklyAttendance()
    }
    
    func viewSetUp() {
        // Spreadsheet
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.delegate = self
        self.spreadsheetView.bounces = false
        self.spreadsheetView.showsVerticalScrollIndicator = false
        self.spreadsheetView.showsHorizontalScrollIndicator = false
        self.spreadsheetView.allowsSelection = false
        self.spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        self.spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        // Calendar
        self.calendarView.scope = .week // Needed to show the weekly at start!
        self.calendarView.allowsMultipleSelection = true
        self.selectedAllDateOfTheWeek(self.calendarView.selectedDate ?? Date.now)
    }

    func populateWeeklyAttendance() {
        for item in self.weeklyAttendance {
            item.attendanceNumber = 0 // We need to clear all attendences
        }
        for day in self.daysOfThisWeek {
            let morningPersons = CoreDataService.shared.getAttendancePerson(day, type: .morning)
            let eveningPersons = CoreDataService.shared.getAttendancePerson(day, type: .evening)
            for person in morningPersons {
                if let index = self.weeklyAttendance.firstIndex(where: {$0.person.name == person.name}) {
                    self.weeklyAttendance[index].attendanceNumber += 1
                }
            }
            for person in eveningPersons {
                if let index = self.weeklyAttendance.firstIndex(where: {$0.person.name == person.name}) {
                    self.weeklyAttendance[index].attendanceNumber += 1
                }
            }
        }
        self.spreadsheetView.reloadData()
    }
}

