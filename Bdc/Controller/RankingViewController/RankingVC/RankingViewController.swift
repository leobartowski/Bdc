//
//  RankingViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import FSCalendar
import PDFKit
import UIKit
import SwiftConfettiView

class RankingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet var tableView: UITableView!
    // Handle Period
    @IBOutlet var containerPeriodView: UIView!
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var monthYearDatePicker: MonthYearPickerView!
    @IBOutlet var yearDatePicker: YearPickerView!
    @IBOutlet var allTimeLabel: UILabel!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    // Handle Slot
    @IBOutlet weak var slotLabel: UILabel!
    @IBOutlet var containerSlotView: UIView!
    
    var rankingPersonsAttendaces: [RankingPersonAttendance] = []
    let headerBasic = ["Nome", "P", "A"]
    var header: [String] = []
    var sorting = SortingPositionAndType(.attendance, .descending) // This variable is needed to understand which column in sorted and if ascending or descending (type)
    var daysCurrentPeriod = [Date]() // The first time is inizialized in the setup of RankingTypeTableViewCell
    var holidaysNumbers: [Int] = [] // We calculate the holiday number here to avoid doing calculation several times in the cell
    var selectedCellRow = -1
    var rankingType: RankingType = .weekly
    var slotType: SlotType = .morningAndEvening
    var confettiView: SwiftConfettiView?
    var showBorderForHighlithCell = false
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: Lifecycle
    
    override func viewDidLayoutSubviews() {
        self.containerPeriodView.layer.shadowPath = UIBezierPath(roundedRect: self.containerPeriodView.bounds, cornerRadius: 15).cgPath
        self.containerSlotView.layer.shadowPath = UIBezierPath(roundedRect: self.containerSlotView.bounds, cornerRadius: 8).cgPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rankingPersonsAttendaces = PersonListUtility.rankingPersonsAttendance
        self.viewSetUp()
        self.setupHandlePeriodView()
        self.setupSlotView()
        self.addObservers()
        self.loadCurrentWeekData()
        self.handleTraitChange()
    }
    
    func viewSetUp() {
        self.navigationBarSetup()
        self.tableViewSetup()
        self.setupConfettiView()
    }
    
    func navigationBarSetup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.shareButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(self.shareButtonAction))
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Periodo", style: .done, target: self, action: #selector(self.chooseRankingTypePeriod)),
            UIBarButtonItem(title: "Slot", style: .done, target: self, action: #selector(self.chooseSlotTypePeriod))
        ]
    }
    
    func handleTraitChange() {
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.calendarView.reloadData()
            }
        })
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangePersonList(_:)), name: .didChangePersonList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeShowConfetti(_:)), name: .didChangeShowConfetti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateAttendance(_:)), name: .didUpdateAttendance, object: nil)
    }
    
    /// Retrive attendance from CoreData
    func populateAttendance() {
        self.showLoader()
        DispatchQueue.main.async {
            self.cleanValuesAttendance()
            for day in self.daysCurrentPeriod {
                let morningAttendance = CoreDataService.shared.getAttendace(day, type: .morning)
                let eveningAttendance = CoreDataService.shared.getAttendace(day, type: .evening)
                let morningPersons = morningAttendance?.persons?.allObjects as? [Person] ?? []
                let eveningPersons = eveningAttendance?.persons?.allObjects as? [Person] ?? []
                let morningPersonsAdmonished = morningAttendance?.personsAdmonished?.allObjects as? [Person] ?? []
                let eveningPersonsAdmonished = eveningAttendance?.personsAdmonished?.allObjects as? [Person] ?? []
                
                for person in morningPersons {
                    if let index = self.rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }),
                       self.slotType == .morningAndEvening || self.slotType == .morning {
                        self.rankingPersonsAttendaces[index].attendanceNumber += 1
                        self.rankingPersonsAttendaces[index].morningDate.append(day)
                    }
                }
                for person in eveningPersons {
                    if let index = self.rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }),
                       self.slotType == .morningAndEvening || self.slotType == .evening {
                        self.rankingPersonsAttendaces[index].attendanceNumber += 1
                        self.rankingPersonsAttendaces[index].eveningDate.append(day)
                    }
                }
                for person in morningPersonsAdmonished {
                    if let index = self.rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }),
                       self.slotType == .morningAndEvening || self.slotType == .morning {
                        self.rankingPersonsAttendaces[index].admonishmentNumber += 1
                        self.rankingPersonsAttendaces[index].morningAdmonishmentDate.append(day)
                    }
                }
                for person in eveningPersonsAdmonished {
                    if let index = self.rankingPersonsAttendaces.firstIndex(where: { $0.person.name == person.name }),
                       self.slotType == .morningAndEvening || self.slotType == .evening {
                        self.rankingPersonsAttendaces[index].admonishmentNumber += 1
                        self.rankingPersonsAttendaces[index].eveningAdmonishmentDate.append(day)
                    }
                }
            }
            self.createHoldayDatesNumberArrayIfNeeded()
            self.sortDescendingAttendanceFirstTime()
            self.hideLoader()
        }
    }
    
    func cleanValuesAttendance() {
        for item in self.rankingPersonsAttendaces {
            item.eveningDate = []
            item.morningDate = []
            item.eveningAdmonishmentDate = []
            item.morningAdmonishmentDate = []
            item.possibleAttendanceNumber = self.daysCurrentPeriod.count
            if self.slotType == .morningAndEvening {
                item.possibleAttendanceNumber = self.daysCurrentPeriod.count * 2
            }
            item.attendanceNumber = 0
            item.admonishmentNumber = 0
        }
    }
    
    func calculateShowBorderForHighlighthCell() -> Bool {
        guard let lastDay = self.daysCurrentPeriod.last else { return false }
        let today = Date()
        let dayOfWeek = today.getDayNumberOfWeek()
        let weekNumber = dayOfWeek == 1 ? today.twoDayBefore.getWeekNumber() : today.getWeekNumber()
        return lastDay.getWeekNumber() == weekNumber && (dayOfWeek == 7 || dayOfWeek == 1)
    }
    
    private func loadCurrentWeekData( ) {
        self.selectedAllDateOfTheWeek(self.calendarView.selectedDate ?? Date.now)
        self.showBorderForHighlithCell = self.calculateShowBorderForHighlighthCell()
        self.populateAttendance()
    }
    
    @objc func didChangePersonList(_: Notification) {
        self.rankingPersonsAttendaces.removeAll()
        self.rankingPersonsAttendaces = PersonListUtility.rankingPersonsAttendance
        self.populateAttendance()
    }
    
    @objc func didUpdateAttendance(_: Notification) {
        self.populateAttendance()
    }
    
    // MARK: Share pdf current period
    @objc func shareButtonAction() {
        
        let pdfTitle = PDFCreator.createPDFTitle(dates: self.daysCurrentPeriod, self.rankingType, self.slotType)
        let pdfData = createPDF(pdfTitle)
        
        let temporaryFolder = FileManager.default.temporaryDirectory
        let pdfFileName = pdfTitle.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
        let temporaryFileURL = temporaryFolder.appendingPathComponent(pdfFileName + ".pdf")
        
        do {
            try pdfData.write(to: temporaryFileURL)
            let vc = UIActivityViewController(activityItems: [temporaryFileURL], applicationActivities: [])
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
                self.present(vc, animated: true, completion: nil)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: Loader
    func showLoader() {
        if self.spinnerView.isHidden && !(self.rankingType == .weekly || self.rankingType == .monthly) {
            self.spinnerView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hideLoader() {
        if !self.spinnerView.isHidden {
            self.activityIndicatorView.stopAnimating()
            self.spinnerView.isHidden = true
        }
    }
    
    // MARK: Present modal to change ranking type
    @objc func chooseRankingTypePeriod() {
        self.presentModalToChangeRankingType()
    }
    
    // MARK: Present modal to change slot type
    @objc func chooseSlotTypePeriod() {
        self.presentModalToChangeSlotType()
    }
}
