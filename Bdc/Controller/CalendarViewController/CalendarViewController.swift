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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    let sectionTitles = ["Presenti", "Assenti"]
    var dayType = DayType.morning
    var personsPresent: [Person] = []
    var personsNotPresent: [Person] = []
    var personsAdmonished: [Person] = []
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.scope = .week // Needed to show the weekly at start! (BUG IN THE SYSTEM)
        self.checkAndChangeWeekendSelectedDate()
        self.getDataFromCoreDataAndReloadViews()
        self.addCalendarGestureRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // Needed to update the Maximum Date when the app remains in RAM
    override func viewWillAppear(_ animated: Bool) {
//        self.calendarView.reloadData()
//        if Date.now.days(from: self.calendarView.maximumDate) < 0 {
//            self.calendarView.reloadData()
//        }
    }
    
    // MARK: - Notification oberserver methods

    @objc func didBecomeActive() {
        
    }

//   Get called when the app is no longer active and loses focus.
    @objc func willResignActive() {
        //When the app lose focus we need to save the value in CoreData without clearing everything
        self.saveCurrentDataInCoreData(clearAll: false)
    }
    
    func checkAndChangeWeekendSelectedDate() {
        
        if Date.now.dayNumberOfWeek() == 1 { // Sunday
            self.calendarView.select(Date.tomorrow) // select Monday
            self.calendarView.today = nil // needed to avoid the red pointer!
        } else if Date.now.dayNumberOfWeek() == 7 { // Saturday
            self.calendarView.select(Date.yesterday) // select Friday
            self.calendarView.today = nil
        }
    }
    
    // MARK: General utils
    
    /// Update Presence reloading data from CoreData
    func getDataFromCoreDataAndReloadViews() {
        let attendance =  CoreDataService.shared.getAttendace(self.calendarView.selectedDate ?? Date.now, type: self.dayType)
        self.personsPresent = attendance?.persons?.allObjects as? [Person] ?? []
        for person in PersonListUtility.persons {
            if !self.personsPresent.contains(where: { $0.name == person.name }) && !self.personsNotPresent.contains(where: { $0.name == person.name })  {
                self.personsNotPresent.append(person)
            }
        }
        self.personsAdmonished = attendance?.personsAdmonished?.allObjects as? [Person] ?? []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    /// Save everything to Core Data and clear current class var before chainging data source. Use this function before updating current date and current dayType
    func saveCurrentDataInCoreData(clearAll: Bool = true) {
        CoreDataService.shared.savePersonsAndPersonsAdmonishedAttendance(self.calendarView.selectedDate ?? Date.now, self.dayType, persons: self.personsPresent, personsAdmonished: self.personsAdmonished)
        if clearAll {
        self.personsPresent.removeAll()
        self.personsNotPresent.removeAll()
        self.personsAdmonished.removeAll()
        }
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

