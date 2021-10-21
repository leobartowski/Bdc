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
    
    let sectionTitles = ["Mattina", "Pomeriggio"]
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createFakeData()
    }
    
    // MARK: Calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.setUp(title: self.sectionTitles[section])
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: Fake DAta CoreDAta
    func createFakeData() {
        let person = Person()
        person.name = "Francesco"
        let person1 = Person()
        person.name = "Afj"
        let person2 = Person()
        person.name = "Ffes"
        let person3 = Person()
        person.name = "grtge"
        
        let persons = [person, person1, person2, person3]
        let date = Date.now
        CoreDataService.shared.saveAttendance(date, persons, .evening)
        
    }


}

