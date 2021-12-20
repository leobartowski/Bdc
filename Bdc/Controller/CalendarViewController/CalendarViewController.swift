//
//  ViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import FSCalendar
import UIKit

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

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCalendarAppearance()
        setupSegmentedControl()
        checkAndChangeWeekendSelectedDate()
        getDataFromCoreDataAndReloadViews()
        addCalendarGestureRecognizer()
        designBottomCalendarHandleView()
        updateGoToTodayButton()

        //        self.setupCollectionView()
        addObservers()
    }

    // We save everything to core data to prepare the new data for the RankingVC
    override func viewWillDisappear(_: Bool) {
        // When the user change controller we need to save the value in CoreData without clearing everything
        //        self.saveCurrentDataInCoreData()
    }

    //   Get called when the app is no longer active and loses focus.
    @objc func willResignActive() {
        // When the app lose focus we need to save the value in CoreData without clearing everything
        //        self.saveCurrentDataInCoreData()
    }

    //   Get called when the app is become active
    @objc func willBecomeActive() {
        updateDayTypeBasedOnTime()
    }

    @objc func systemTimeChanged() {
        updateCalendarIfNeeded()
    }

    // MARK: Utils and Design

    /// Add shadow and corner radius to bottom Calendar Handle View
    func designBottomCalendarHandleView() {
        bottomCalendarHandleView.layer.shadowColor = Theme.FSCalendarStandardLightSelectionColor.cgColor
        bottomCalendarHandleView.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        bottomCalendarHandleView.layer.shadowOpacity = 0.5
        bottomCalendarHandleView.layer.shadowRadius = 2
        bottomCalendarHandleView.layer.masksToBounds = false
        bottomCalendarHandleView.layer.cornerRadius = 20
        bottomCalendarHandleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
    }

    func updateGoToTodayButton() {
        goToTodayButton.alpha = Date().getDayNumberOfWeek() == 1 || Date().getDayNumberOfWeek() == 7
            ? 0.3
            : 1
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
        segmentedControl.backgroundColor = .white
        segmentedControl.layer.shadowColor = Theme.FSCalendarStandardLightSelectionColor.cgColor
        segmentedControl.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        segmentedControl.layer.shadowOpacity = 0.5
        segmentedControl.layer.shadowRadius = 3
        segmentedControl.layer.masksToBounds = false
        segmentedControl.borderColor = Theme.FSCalendarStandardSelectionColor
        segmentedControl.selectedSegmentTintColor = Theme.FSCalendarStandardSelectionColor
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)

        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }

    // MARK: Morning and Evening Selector

    func updateDayTypeBasedOnTime() {
        let todayString = DateFormatter.basicFormatter.string(from: Date.now)
        let currentDayString = DateFormatter.basicFormatter.string(from: calendarView.selectedDate ?? Date())
        if todayString == currentDayString {
            var calendar = Calendar.current
            calendar.locale = .current
            let hour = calendar.component(.hour, from: Date.now)
            let oldDayType = dayType
            if hour < 16, hour > 8 { // morning
                dayType = .morning
                segmentedControl.selectedSegmentIndex = 0
            } else { // evening
                dayType = .evening
                segmentedControl.selectedSegmentIndex = 1
            }
            // We reload data from CoreData only if dayType is changed
            if oldDayType != dayType { getDataFromCoreDataAndReloadViews() }
        }
    }

    func reloadCalendarDateIfNeeded() {
        if calendarView.maximumDate < Date.now {
            updateGoToTodayButton()
            calendarView.reloadData()
        }
    }

    // MARK: Functions to fetch and save CoreData

    /// Update Presence reloading data from CoreData
    func getDataFromCoreDataAndReloadViews() {
        personsPresent.removeAll()
        personsNotPresent.removeAll()
        personsAdmonished.removeAll()
        let attendance = CoreDataService.shared.getAttendace(calendarView.selectedDate ?? Date.now, type: dayType)
        personsPresent = attendance?.persons?.allObjects as? [Person] ?? []
        personsAdmonished = attendance?.personsAdmonished?.allObjects as? [Person] ?? []
        for person in PersonListUtility.persons {
            if !personsPresent.contains(where: { $0.name == person.name }), !personsNotPresent.contains(where: { $0.name == person.name }) {
                personsNotPresent.append(person)
            }
        }

        sortPersonPresentAndNot()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(.zero, animated: true)
        }
    }

    func sortPersonPresentAndNot() {
        personsPresent = personsPresent.sorted { $0.name ?? "" < $1.name ?? "" }
        personsNotPresent = personsNotPresent.sorted { $0.name ?? "" < $1.name ?? "" }
    }

    // MARK: IBActions

    @IBAction func segmentedControlValueChanged(_: Any) {
        //        self.saveCurrentDataInCoreData()
        switch segmentedControl.selectedSegmentIndex {
        case 0: dayType = .morning
        case 1: dayType = .evening
        default: break
        }
        getDataFromCoreDataAndReloadViews()
    }

    @IBAction func goToTodayTouchUpInside(_: Any) {
        Date().getDayNumberOfWeek() == 1 || Date().getDayNumberOfWeek() == 7
            ? presentAlert(alertText: "Hey!", alertMessage: "Mi dispiace, ma dovresti sapere che non si prendono presenze sabato e domenica!")
            : automaticScrollToToday()
    }

    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .up:
                handleMonthlyToWeeklyCalendar()
            case .down:
                handleWeeklyToMonthlyCalendar()
            default:
                break
            }
        }
    }
}
