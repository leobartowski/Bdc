//
//  ViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import FSCalendar
import UIKit
import SwiftHoliday

class CalendarViewController: UIViewController {
    
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentedControl: MySegmentedControl!
    @IBOutlet var bottomCalendarHandleView: UIView!
    @IBOutlet var goToTodayButton: UIButton!
    @IBOutlet var segmentedControlContainerView: UIView!

    @IBOutlet var calendarViewHeightConstraint: NSLayoutConstraint!
    let sectionTitles = ["Presenti", "Assenti"]
    var dayType = DayType.evening
    var personsPresent: [Person] = []
    var personsNotPresent: [Person] = []
    var personsAdmonished: [Person] = []
    var canModifyOldDays = false

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpCalendarAppearance()
        self.setupSegmentedControl()
        self.getDataFromCoreDataAndReloadViews()
        self.addCalendarGestureRecognizer()
        self.designBottomCalendarHandleView()
        self.updateGoToTodayButton()
        self.addObservers()
        self.canModifyOldDays = UserDefaults.standard.bool(forKey: "modifyOldDays")
    }

    //   Get called when the app is become active
    @objc func willBecomeActive() {
        self.updateDayTypeBasedOnTime()
    }

    @objc func systemTimeChanged() {
        self.updateCalendarIfNeeded()
    }

    // MARK: Utils and Design

    /// Add shadow and corner radius to bottom Calendar Handle View
    func designBottomCalendarHandleView() {
        self.bottomCalendarHandleView.layer.shadowColor = UIColor.gray.cgColor
        self.bottomCalendarHandleView.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        self.bottomCalendarHandleView.layer.shadowOpacity = 0.3
        self.bottomCalendarHandleView.layer.shadowRadius = 2
        self.bottomCalendarHandleView.layer.masksToBounds = false
        self.bottomCalendarHandleView.layer.cornerRadius = 13
        self.bottomCalendarHandleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeModifyStatus(_:)), name: .didChangeModifyStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangePersonList(_:)), name: .didChangePersonList, object: nil)
}

    func updateGoToTodayButton() {
        self.goToTodayButton.alpha = Date().isThisDaySelectable() ? 1 : 0.3
    }

    func automaticScrollToToday() {
        //        self.saveCurrentDataInCoreData() // save the date of the current day before deselecting
        DispatchQueue.main.async {
            self.calendarView.setCurrentPage(Date.now, animated: true)
            self.calendarView.select(Date.now)
            self.getDataFromCoreDataAndReloadViews()
        }
    }

    func setupSegmentedControl() {
        self.segmentedControl.backgroundColor = .white
        self.segmentedControl.layer.shadowColor = Theme.FSCalendarStandardLightSelectionColor.cgColor
        self.segmentedControl.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.segmentedControl.layer.shadowOpacity = 0.5
        self.segmentedControl.layer.shadowRadius = 3
        self.segmentedControl.layer.masksToBounds = false
        self.segmentedControl.borderColor = Theme.FSCalendarStandardSelectionColor
        self.segmentedControl.selectedSegmentTintColor = Theme.FSCalendarStandardSelectionColor
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)

        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }

    // MARK: Morning and Evening Selector

    func updateDayTypeBasedOnTime() {
        let todayString = DateFormatter.basicFormatter.string(from: Date.now)
        let currentDayString = DateFormatter.basicFormatter.string(from: self.calendarView.selectedDate ?? Date())
        if todayString == currentDayString {
            var calendar = Calendar.current
            calendar.locale = .current
            let hour = calendar.component(.hour, from: Date.now)
            let oldDayType = self.dayType
            if hour < 16, hour > 8 { // morning
                self.dayType = .morning
                self.segmentedControl.selectedSegmentIndex = 0
            } else { // evening
                self.dayType = .evening
                self.segmentedControl.selectedSegmentIndex = 1
            }
            // We reload data from CoreData only if dayType is changed
            if oldDayType != self.dayType { self.getDataFromCoreDataAndReloadViews() }
        }
    }

    func reloadCalendarDateIfNeeded() {
        if self.calendarView.maximumDate < Date.now {
            self.updateGoToTodayButton()
            self.calendarView.reloadData()
        }
    }

    // MARK: Functions to fetch and save CoreData

    /// Update Presence reloading data from CoreData
    func getDataFromCoreDataAndReloadViews() {
        self.personsPresent.removeAll()
        self.personsNotPresent.removeAll()
        self.personsAdmonished.removeAll()
        let attendance = CoreDataService.shared.getAttendace(self.calendarView.selectedDate ?? Date.now, type: self.dayType)
        self.personsPresent = attendance?.persons?.allObjects as? [Person] ?? []
        self.personsAdmonished = attendance?.personsAdmonished?.allObjects as? [Person] ?? []
        for person in PersonListUtility.persons {
            if !self.personsPresent.contains(where: { $0.name == person.name }), !self.personsNotPresent.contains(where: { $0.name == person.name }) {
                self.personsNotPresent.append(person)
            }
        }

        self.sortPersonPresentAndNot()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(.zero, animated: true)
        }
    }

    func sortPersonPresentAndNot() {
        self.personsPresent = self.personsPresent.sorted { $0.name ?? "" < $1.name ?? "" }
        self.personsNotPresent = self.personsNotPresent.sorted { $0.name ?? "" < $1.name ?? "" }
    }

    
    // MARK: Handle settings
    @objc func didChangeModifyStatus(_: Notification) {
        self.canModifyOldDays = UserDefaults.standard.bool(forKey: "modifyOldDays")
    }
    
    // MARK: Handle settings
    @objc func didChangePersonList(_: Notification) {
        self.getDataFromCoreDataAndReloadViews()
    }

    // MARK: IBActions

    @IBAction func segmentedControlValueChanged(_: Any) {
        //        self.saveCurrentDataInCoreData()
        switch self.segmentedControl.selectedSegmentIndex {
        case 0: self.dayType = .morning
        case 1: self.dayType = .evening
        default: break
        }
        self.getDataFromCoreDataAndReloadViews()
    }

    @IBAction func goToTodayTouchUpInside(_: Any) {
        !Date().isThisDaySelectable()
        ? self.presentAlert(alertText: "Hey!", alertMessage: "Mi dispiace, ma dovresti sapere che oggi non si prendono presenze!")
        : self.automaticScrollToToday()
    }

    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .up:
                self.handleMonthlyToWeeklyCalendar()
            case .down:
                self.handleWeeklyToMonthlyCalendar()
            default:
                break
            }
        }
    }
}
