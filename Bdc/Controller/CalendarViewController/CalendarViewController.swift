//
//  ViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: MySegmentedControl!
    @IBOutlet weak var bottomCalendarHandleView: UIView!
    @IBOutlet weak var goToTodayButton: UIButton!
    @IBOutlet weak var segmentedControlContainerView: UIView!
    
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    let sectionTitles = ["Presenti", "Assenti"]
    var dayType = DayType.evening
    var personsPresent: [Person] = []
    var personsNotPresent: [Person] = []
    var personsAdmonished: [Person] = []
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCalendarAppearance()
        self.setupSegmentedControl()
        self.checkAndChangeWeekendSelectedDate()
        self.getDataFromCoreDataAndReloadViews()
        self.addCalendarGestureRecognizer()
        self.designBottomCalendarHandleView()
        self.updateGoToTodayButton()
        
        //        self.setupCollectionView()
        self.addObservers()
    }
    
    // We save everything to core data to prepare the new data for the RankingVC
    override func viewWillDisappear(_ animated: Bool) {
        //When the user change controller we need to save the value in CoreData without clearing everything
        //        self.saveCurrentDataInCoreData()
    }
    
    //   Get called when the app is no longer active and loses focus.
    @objc func willResignActive() {
        //When the app lose focus we need to save the value in CoreData without clearing everything
        //        self.saveCurrentDataInCoreData()
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
        self.bottomCalendarHandleView.layer.shadowColor = Theme.FSCalendarStandardLightSelectionColor.cgColor
        self.bottomCalendarHandleView.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        self.bottomCalendarHandleView.layer.shadowOpacity = 0.5
        self.bottomCalendarHandleView.layer.shadowRadius = 2
        self.bottomCalendarHandleView.layer.masksToBounds = false
        self.bottomCalendarHandleView.layer.cornerRadius = 20
        self.bottomCalendarHandleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    func updateGoToTodayButton() {
        self.goToTodayButton.alpha = Date().getDayNumberOfWeek() == 1 || Date().getDayNumberOfWeek() == 7
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
            if (hour < 16 && hour > 8) { // morning
                self.dayType = .morning
                self.segmentedControl.selectedSegmentIndex = 0
            } else  { // evening
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
        let attendance =  CoreDataService.shared.getAttendace(self.calendarView.selectedDate ?? Date.now, type: self.dayType)
        self.personsPresent = attendance?.persons?.allObjects as? [Person] ?? []
        self.personsAdmonished = attendance?.personsAdmonished?.allObjects as? [Person] ?? []
        for person in PersonListUtility.persons {
            if !self.personsPresent.contains(where: { $0.name == person.name }) && !self.personsNotPresent.contains(where: { $0.name == person.name })  {
                self.personsNotPresent.append(person)
            }
        }
        
        self.sortPersonPresentAndNot()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(.zero, animated: true)
        }
    }
    
    /// Save everything to Core Data and clear current class var before chainging data source. Use this function before updating current date and current dayType
    func saveCurrentDataInCoreData() {
        DispatchQueue.main.async {
            CoreDataService.shared.savePersonsAndPersonsAdmonishedAttendance(self.calendarView.selectedDate ?? Date.now, self.dayType, persons: self.personsPresent, personsAdmonished: self.personsAdmonished)
        }
        
    }
    
    func sortPersonPresentAndNot() {
        self.personsPresent = self.personsPresent.sorted{ $0.name ?? "" < $1.name ?? "" }
        self.personsNotPresent = self.personsNotPresent.sorted{ $0.name ?? "" < $1.name ?? "" }
    }
    
    
    // MARK: IBActions
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
        //        self.saveCurrentDataInCoreData()
        switch segmentedControl.selectedSegmentIndex {
        case 0: self.dayType = .morning
        case 1: self.dayType = .evening
        default:break
        }
        self.getDataFromCoreDataAndReloadViews()
    }
    
    @IBAction func goToTodayTouchUpInside(_ sender: Any) {
        
        Date().getDayNumberOfWeek() == 1 || Date().getDayNumberOfWeek() == 7
        ? self.presentAlert(alertText: "Hey!", alertMessage: "Mi dispiace, ma dovresti sapere che non si prendono presenze sabato e domenica!")
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

