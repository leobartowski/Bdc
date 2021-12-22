//
//  RankingViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import FSCalendar
import PDFKit
import UIKit

class RankingViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var changeRankingTypeButton: UIButton!

    var rankingPersonsAttendaces = PersonListUtility.rankingPersonsAttendance
    let headerBasic = ["Nome", "P", "A"]
    var header: [String] = []
    var sorting = SortingPositionAndType(.attendance, .descending) // This variable is needed to understand which column in sorted and if ascending or descending (type)
    var daysOfThisWeek = [Date]()
    var selectedCellRow = -1
    var rankingType: RankingType = .weekly

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetUp()
    }

    // We update the data in the DidAppear to have always data updated after some modification
    override func viewDidAppear(_: Bool) {
        self.populateWeeklyAttendance()
    }

    func viewSetUp() {
        // Table View
        tableViewSetup()
        // Calendar
        calendarSetup()
    }

    func populateWeeklyAttendance() {
        for item in self.rankingPersonsAttendaces {
            // We need to clear all presences and adomishment
            item.eveningDate = []
            item.morningDate = []
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
                if let index = rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }) {
                    self.rankingPersonsAttendaces[index].attendanceNumber += 1
                    self.rankingPersonsAttendaces[index].morningDate.append(day)
                }
            }
            for person in eveningPersons {
                if let index = rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }) {
                    self.rankingPersonsAttendaces[index].attendanceNumber += 1
                    self.rankingPersonsAttendaces[index].eveningDate.append(day)
                }
            }
            for person in morningPersonsAdmonished {
                if let index = rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }) {
                    self.rankingPersonsAttendaces[index].admonishmentNumber += 1
                }
            }
            for person in eveningPersonsAdmonished {
                if let index = rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }) {
                    self.rankingPersonsAttendaces[index].admonishmentNumber += 1
                }
            }
        }
        sortDescendingAttendanceFirstTime()
    }

    @IBAction func shareButtonAction(_: Any) {
        let pdfTitle = PDFCreator.createPDFTitle(dates: self.daysOfThisWeek)
        let pdfData = createPDF(pdfTitle)

        let temporaryFolder = FileManager.default.temporaryDirectory
        let pdfFileName = pdfTitle.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
        let temporaryFileURL = temporaryFolder.appendingPathComponent(pdfFileName + ".pdf")

        do {
            try pdfData.write(to: temporaryFileURL)
            let vc = UIActivityViewController(activityItems: [temporaryFileURL], applicationActivities: [])
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        } catch {
            print(error)
        }
    }

    @IBAction func changeRankingTypeAction(_: Any) {
        presentModalToChangeRankingType()
    }
}
