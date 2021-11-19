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
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    let sectionTitles = ["Presenti", "Assenti"]
    var dayType = DayType.evening
    var personsPresent: [Person] = []
    var personsNotPresent: [Person] = []
    var personsAdmonished: [Person] = []
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendarView.scope = .week // Needed to show the weekly at start! (BUG IN THE SYSTEM)
        self.setUpCalendarAppearance()
        self.checkAndChangeWeekendSelectedDate()
        self.getDataFromCoreDataAndReloadViews()
        self.addCalendarGestureRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    // We save everything to core data to prepare the new data for the RankingVC
    override func viewWillDisappear(_ animated: Bool) {
        //When the user change controller we need to save the value in CoreData without clearing everything
        self.saveCurrentDataInCoreData()
    }
    
    //   Get called when the app is no longer active and loses focus.
    @objc func willResignActive() {
        //When the app lose focus we need to save the value in CoreData without clearing everything
        self.saveCurrentDataInCoreData()
    }
    
    //   Get called when the app is become active
    @objc func willBecomeActive() {
        self.updateDayTypeBasedOnTime()
    }
    
    @objc func systemTimeChanged() {
        self.updateCalendarIfNeeded()
    }
    
    
    // MARK: Morning and Evening Selector
    func updateDayTypeBasedOnTime() {
        let todayString = DateFormatter.basicFormatter.string(from: Date.now)
        let currentDayString = DateFormatter.basicFormatter.string(from: self.calendarView.selectedDate ?? Date())
        if todayString == currentDayString {
            var calendar = Calendar.current
            calendar.locale = .current
            let hour = calendar.component(.hour, from: Date.now)
            if (hour < 16 && hour > 8) { // morning
                self.dayType = .morning
                self.segmentedControl.selectedSegmentIndex = 0
            } else { // evening
                self.dayType = .evening
                self.segmentedControl.selectedSegmentIndex = 1
            }
            self.getDataFromCoreDataAndReloadViews()
        }
    }
    
    func reloadCalendarDateIfNeeded() {
        if self.calendarView.maximumDate < Date.now {
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
        for person in PersonListUtility.persons {
            if !self.personsPresent.contains(where: { $0.name == person.name }) && !self.personsNotPresent.contains(where: { $0.name == person.name })  {
                self.personsNotPresent.append(person)
            }
        }
        self.personsAdmonished = attendance?.personsAdmonished?.allObjects as? [Person] ?? []
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    /// Save everything to Core Data and clear current class var before chainging data source. Use this function before updating current date and current dayType
    func saveCurrentDataInCoreData() {
        CoreDataService.shared.savePersonsAndPersonsAdmonishedAttendance(self.calendarView.selectedDate ?? Date.now, self.dayType, persons: self.personsPresent, personsAdmonished: self.personsAdmonished)
    }
    
    // MARK: IBActions
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        
        self.saveCurrentDataInCoreData()
        switch segmentedControl.selectedSegmentIndex {
        case 0: self.dayType = .morning
        case 1: self.dayType = .evening
        default:break
        }
        self.getDataFromCoreDataAndReloadViews()
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

