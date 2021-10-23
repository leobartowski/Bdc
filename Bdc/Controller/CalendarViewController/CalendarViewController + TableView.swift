//
//  CalendarViewController + TableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import UIKit

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Delegate e DataSource
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
    
    
}
