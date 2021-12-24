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
    @IBOutlet var changeRankingTypeButton: UIButton!
    @IBOutlet var monthYearDatePicker: MonthYearPickerView!
    @IBOutlet var yearDatePicker: YearPickerView!
    @IBOutlet var containerViewForRankingType: UIView!
    // Constraints
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    var rankingPersonsAttendaces = PersonListUtility.rankingPersonsAttendance
    let headerBasic = ["Nome", "P", "A"]
    var header: [String] = []
    var sorting = SortingPositionAndType(.attendance, .descending) // This variable is needed to understand which column in sorted and if ascending or descending (type)
    var daysCurrentPeriod = [Date]()
    var selectedCellRow = -1
    var rankingType: RankingType = .weekly

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetUp()
    }

    // We update the data in the DidAppear to have always data updated after some modification
    override func viewDidAppear(_: Bool) {
            self.populateAttendance()
    }
    
    override func viewDidLayoutSubviews() {
        self.containerViewForRankingType.layer.shadowPath = UIBezierPath(roundedRect: self.containerViewForRankingType.bounds, cornerRadius: 15).cgPath
    }

    func viewSetUp() {
        // UI
        self.setupShadowContainerView()
        // Table View
        self.tableViewSetup()
        // Calendar
        self.calendarSetup()
        // Month and Year Date Picker
        self.monthYearDatePickerSetup()
        // Year Date Picker
        self.yearDatePickerSetup()
    }
    
    func setupShadowContainerView() {
        let cornerRadius: CGFloat = 15
        self.containerViewForRankingType.cornerRadius = cornerRadius
        self.containerViewForRankingType.layer.masksToBounds = true
        self.containerViewForRankingType.layer.shadowColor = UIColor.gray.cgColor
        self.containerViewForRankingType.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerViewForRankingType.layer.shadowOpacity = 0.3
        self.containerViewForRankingType.layer.shadowRadius = 2
        self.containerViewForRankingType.layer.shadowPath = UIBezierPath(roundedRect: self.containerViewForRankingType.bounds, cornerRadius: cornerRadius).cgPath
        self.containerViewForRankingType.layer.masksToBounds = false
    }

    /// Retrive attendance from CoreData
    func populateAttendance() {
        for item in self.rankingPersonsAttendaces {
            // We need to clear all presences and adomishment
            item.eveningDate = []
            item.morningDate = []
            item.attendanceNumber = 0
            item.admonishmentNumber = 0
        }
        for day in self.daysCurrentPeriod {
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
        self.sortDescendingAttendanceFirstTime()
    }

    @IBAction func shareButtonAction(_: Any) {
        let pdfTitle = PDFCreator.createPDFTitle(dates: self.daysCurrentPeriod)
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
        self.presentModalToChangeRankingType()
    }
}
