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
        self.updatePresences()
        self.addCalendarGestureRecognizer()
    }
    
    // Needed to update the Maximum Date when the app remains in RAM
    override func viewWillAppear(_ animated: Bool) {
        if self.calendarView.maximumDate < Date.now {
            self.calendarView.reloadData()
        }
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
    func updatePresences() {
        self.personsNotPresent = []
        let attendance =  CoreDataService.shared.getAttendace(self.calendarView.selectedDate ?? Date.now, type: self.dayType)
        self.personsPresent = attendance?.persons?.allObjects as? [Person] ?? []
        for person in PersonListUtility.persons {
            if !self.personsPresent.contains(where: { $0.name == person.name }) && !self.personsNotPresent.contains(where: { $0.name == person.name })  {
                self.personsNotPresent.append(person)
            }
        }
        self.personsAdmonished = attendance?.personsAdmonished?.allObjects as? [Person] ?? []
        DispatchQueue.main.async {
            self.tableView.reloadData() // TODO: FIX THIS
        }
        
    }
    
    // MARK: IBActions
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: self.dayType = .morning
        case 1: self.dayType = .evening
        default:break
        }
        self.updatePresences()
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

