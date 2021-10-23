//
//  ViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
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
        self.updatePresences()
        self.addCalendarGestureRecognizer()
    }
    
    func addCalendarGestureRecognizer() {
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureUp.direction = .up
        self.calendarView.addGestureRecognizer(swipeGestureUp)
        
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeGestureDown.direction = .down
        self.calendarView.addGestureRecognizer(swipeGestureDown)
    }

    
    // MARK: Calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.updatePresences()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return (date.dayNumberOfWeek() == 1 || date.dayNumberOfWeek() == 7) ? false : true
    }
    
    
    
    //    func minimumDate(for calendar: FSCalendar) -> Date {
    //        return DateFormatter.basicFormatter.date(from: "18/10/2021") ?? Date.yesterday
    //    }
    //
    //    func maximumDate(for calendar: FSCalendar) -> Date {
    //        return Date.tomorrow
    //    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.personsPresent.count : self.personsNotPresent.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? MainTableViewCell
        cell?.nameLabel.text = indexPath.section == 0 ? self.personsPresent[indexPath.row].name : self.personsNotPresent[indexPath.row].name
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Person Present
            let personToRemove = self.personsPresent[indexPath.row]
            self.personsPresent.remove(at: indexPath.row)
            self.personsNotPresent.append(personToRemove)
            // We pass always personsPresent because personToRemove override the person that are present
            CoreDataService.shared.saveAttendance(calendarView.selectedDate ?? Date.now, self.personsPresent, self.dayType)
        } else { // Person not present
            let personToAdd = self.personsNotPresent[indexPath.row]
            self.personsNotPresent.remove(at: indexPath.row)
            self.personsPresent.append(personToAdd)
            CoreDataService.shared.saveAttendance(calendarView.selectedDate ?? Date.now, self.personsPresent, self.dayType)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.setUp(title: self.sectionTitles[section])
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
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
    
    //TODO: Understand why with the animation does not work
    func handleWeeklyToMonthlyCalendar() {
        if self.calendarView.scope == .week {
//            self.calendarView.setScope(.month, animated: true)
            self.calendarView.scope = .month
            self.calendarViewHeightConstraint.constant = 350
        }
    }
    
    func handleMonthlyToWeeklyCalendar() {
        if self.calendarView.scope == .month {
//            self.calendarView.setScope(.week, animated: true)
            self.calendarView.scope = .week
            self.calendarViewHeightConstraint.constant = 127
        }
    }
    
}

