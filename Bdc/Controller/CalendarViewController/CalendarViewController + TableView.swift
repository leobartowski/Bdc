//
//  CalendarViewController + TableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import UIKit

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource, MainTableViewCellDelegate {
    
    // MARK: Delegate e DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.personsPresent.count : self.personsNotPresent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? MainTableViewCell
        
        if indexPath.section == 0 {
            cell?.setUp(self.personsPresent[indexPath.row], false, indexPath, self)
        } else {
            let personNotPresent = self.personsNotPresent[indexPath.row]
            let isAmonished = self.personsAdmonished.contains(where: { $0.name == personNotPresent.name })
            cell?.setUp(personNotPresent, isAmonished, indexPath, self)
            
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Person Present
            let personToRemove = self.personsPresent[indexPath.row]
            self.personsPresent.remove(at: indexPath.row)
            self.personsNotPresent.append(personToRemove)
        } else { // Person not present
            let personToAdd = self.personsNotPresent[indexPath.row]
            if self.personsAdmonished.contains(where: { $0.name == personToAdd.name }) {
                self.presentAlert(alertText: "Errore", alertMessage: "Una persona ammonita non pùo risultate presente, rimuovi l'ammonizione e poi procedi ")
                return
            }
            self.personsNotPresent.remove(at: indexPath.row)
            self.personsPresent.append(personToAdd)
        }
        // We pass always personsPresent because personToRemove override the person that are present
        CoreDataService.shared.savePersonsAttendance(calendarView.selectedDate ?? Date.now, self.personsPresent, self.dayType)
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = SectionHeaderView()
        sectionHeaderView.setUp(title: self.sectionTitles[section])
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: MainTableViewCellDelegate
    func mainCell(_ cell: MainTableViewCell, didSelectRowAt indexPath: IndexPath) {
        let personToHandle = self.personsNotPresent[indexPath.row]
        // I need to amonish this person if is not amonished or I need to remove the amonishment otherwise
        !cell.isAmonished ? self.personsAdmonished.append(personToHandle) :  self.personsAdmonished.removeAll(where: { $0.name == personToHandle.name })
        CoreDataService.shared.savePersonsAdmonishedAttendance(self.calendarView.selectedDate ?? Date.now, [personToHandle], self.dayType)
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
