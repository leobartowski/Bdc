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
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.scope = .week // Needed to show the weekly at start! (BUG IN THE SYSTEM)
        self.checkAndChangeWeekendSelectedDate()
        self.updatePresences()
        self.addCalendarGestureRecognizer()
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
    
    /// Update Presence
    func updatePresences() {
        self.personsNotPresent = []
        self.personsPresent = CoreDataService.shared.getAttendancePerson(self.calendarView.selectedDate ?? Date.now, type: self.dayType)
        for person in Utility.persons {
            if !self.personsPresent.contains(where: { $0.name == person.name }) && !self.personsNotPresent.contains(where: { $0.name == person.name })  {
                self.personsNotPresent.append(person)
            }
        }
        self.tableView.reloadData() // TODO: FIX THIS
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
    
    // The animation and the chande of constraints are performed in the delagate method: boundingRectWillChange
    func handleWeeklyToMonthlyCalendar() {
        if self.calendarView.scope == .week {
            self.calendarView.setScope(.month, animated: true)
        }
    }
    
    func handleMonthlyToWeeklyCalendar() {
        if self.calendarView.scope == .month {
            self.calendarView.setScope(.week, animated: true)
        }
    }
    
}

