//
//  RankingViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import UIKit
import FSCalendar

class RankingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    var rankingPersonsAttendaces = PersonListUtility.rankingPersonsAttendance
    let headerBasic = ["Nome", "P", "A"]
    var header: [String] = []
    var sorting = SortingPositionAndType(.attendance, .descending) // This variable is needed to understand which column in sorted and if ascending or descending (type)
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
        // Table View
        self.tableViewSetup()
        // Calendar
        self.calendarSetup()
    }
    
    func populateWeeklyAttendance() {
        for item in self.rankingPersonsAttendaces {
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
                if let index = self.rankingPersonsAttendaces.firstIndex(where: {$0.person.name == person.name}) {
                    self.rankingPersonsAttendaces[index].attendanceNumber += 1
                }
            }
            for person in eveningPersons {
                if let index = self.rankingPersonsAttendaces.firstIndex(where: {$0.person.name == person.name}) {
                    self.rankingPersonsAttendaces[index].attendanceNumber += 1
                }
            }
            for person in morningPersonsAdmonished {
                if let index = self.rankingPersonsAttendaces.firstIndex(where: {$0.person.name == person.name}) {
                    self.rankingPersonsAttendaces[index].admonishmentNumber += 1
                }
            }
            for person in eveningPersonsAdmonished {
                if let index = self.rankingPersonsAttendaces.firstIndex(where: {$0.person.name == person.name}) {
                    self.rankingPersonsAttendaces[index].admonishmentNumber += 1
                }
            }
        }
        self.sortDescendingAttendanceFirstTime()
    }
}




