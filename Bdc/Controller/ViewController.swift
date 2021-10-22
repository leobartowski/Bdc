//
//  ViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import UIKit
import FSCalendar


class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let sectionTitles = ["Presenti", "Assenti"]
    let dayType = DayType.morning
    var personsPresent: [Person] = []
    var personsNotPresent: [Person] = []
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPresence()
    }
    
    // MARK: Calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.checkPresence()
    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.personsPresent.count : self.personsNotPresent.count
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
    func checkPresence() {
        self.personsNotPresent = []
        for person in Utility.persons {
            self.personsPresent = CoreDataService.shared.getAttendancePerson(self.calendarView.selectedDate ?? Date.now, type: self.dayType)
            if !self.personsPresent.contains(where: { $0.name == person.name }) && !self.personsNotPresent.contains(where: { $0.name == person.name })  {
                self.personsNotPresent.append(person)
            }
        }
        self.tableView.reloadData() // TODO: FIX THIS
    }
    
}

