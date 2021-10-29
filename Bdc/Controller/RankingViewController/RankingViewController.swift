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
    
    var weeklyAttendance = PersonListUtility.personsWeeklyAttendance
    let header = ["Nome", "Presenze", "Ammonizioni"]
    var daysOfThisWeek = [Date]()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetUp()
    }
    
    // Needed to update the Maximum Date when the app remains in RAM
    
    // We update the data in the DidAppear to have always data updated after some modification
    override func viewDidAppear(_ animated: Bool) {
        self.populateWeeklyAttendance()
    }
    
    func viewSetUp() {
        // Spreadsheet
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.delegate = self
        self.spreadsheetView.bounces = false
        self.calendarView.today = nil // Removed today but should let the user understand that this is the selected week!
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
            // We need to clear all presences and adomishment
            item.attendanceNumber = 0
            item.admonishmentNumber = 0
        }
        for day in self.daysOfThisWeek {
            let morningAttendance = CoreDataService.shared.getAttendace(day, type: .morning)
            let eveningAttendance = CoreDataService.shared.getAttendace(day, type: .evening)
            let morningPersons = morningAttendance?.persons?.allObjects as? [Person] ?? []
            let eveningPersons = eveningAttendance?.persons?.allObjects as? [Person] ?? []
            let morningPersonsAdmonished = morningAttendance?.personsAdmonished?.allObjects as? [Person] ?? []
            let eveningPersonsAdmonished = eveningAttendance?.personsAdmonished?.allObjects as? [Person] ?? []
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
            for person in morningPersonsAdmonished {
                if let index = self.weeklyAttendance.firstIndex(where: {$0.person.name == person.name}) {
                    self.weeklyAttendance[index].admonishmentNumber += 1
                }
            }
            for person in eveningPersonsAdmonished {
                if let index = self.weeklyAttendance.firstIndex(where: {$0.person.name == person.name}) {
                    self.weeklyAttendance[index].admonishmentNumber += 1
                }
            }
        }
        DispatchQueue.main.async {
            self.spreadsheetView.reloadData()
        }
    }
}

