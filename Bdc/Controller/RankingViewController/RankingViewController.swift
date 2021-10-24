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
    
    // TODO: CLEAN THIS MESS!
    //-----------------------------------------------
    enum Sorting {
        case ascending
        case descending

        var symbol: String {
            switch self {
            case .ascending:
                return "\u{25B2}"
            case .descending:
                return "\u{25BC}"
            }
        }
    }
    var sortedColumn = (column: 0, sorting: Sorting.ascending)
    var data = [[String]]()
    
    //--------------------------------------------
    
    func viewSetUp() {
        // Spreadsheet
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.delegate = self
        self.spreadsheetView.bounces = false
        self.spreadsheetView.showsVerticalScrollIndicator = false
        self.spreadsheetView.showsHorizontalScrollIndicator = false
        self.spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        self.spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        // Calendar
        self.calendarView.scope = .week // Needed to show the weekly at start!
        self.calendarView.allowsMultipleSelection = true
        self.selectedAllDateOfTheWeek(self.calendarView.selectedDate ?? Date.now)
    }
    
    func addExampleData() {
        let data = try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "tsv")!, encoding: .utf8)
            .components(separatedBy: "\r\n")
            .map { $0.components(separatedBy: "\t") }

        self.data = Array(data.dropFirst())
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

