//
//  RankingViewController + TableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 25/11/21.
//

import UIKit

extension RankingViewController: UITableViewDelegate, UITableViewDataSource, RankingSectionHeaderDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankingPersonsAttendaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.isSelected ?? false { return 200 }
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? RankingTableViewCell
        let rankingAttendance = self.rankingPersonsAttendaces[indexPath.row]
        cell?.setUp(rankingAttendance, indexPath)
        cell?.setupLabelDesign(self.sorting.sortingPosition.rawValue)
        self.handleColorOfTheCellOnFriday(cell, indexPath.row)
        cell?.setNeedsLayout()
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return indexPath }
        if selectedIndexPath == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            UIView.animate(withDuration: 0.3) {
                tableView.performBatchUpdates(nil)
            }
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.3) {
            tableView.performBatchUpdates(nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = RankingSectionHeaderView()
        sectionHeaderView.delegate = self
        sectionHeaderView.nameLabel.text = self.header[0]
        sectionHeaderView.attendanceLabel.text = self.header[1]
        sectionHeaderView.admonishmentLabel.text = self.header[2]
        sectionHeaderView.setupLabelDesign(self.sorting.sortingPosition.rawValue)
        return sectionHeaderView
    }
    
    func tableViewSetup() {
        
        self.header = self.headerBasic
    }
    
    func handleColorOfTheCellOnFriday(_ cell: RankingTableViewCell?, _ row: Int) {
        // Show red and green cell only on friday and only if the week on focus is the current week
        if Date().getDayNumberOfWeek() == 6 && self.calendarView.currentPage.getWeekNumber() == Date.now.getWeekNumber() {
            // Check if the user has at least two presence or more than 2 admonishment
            cell?.containerView.layer.shadowOpacity = 0.7
            cell?.containerView.layer.shadowColor = self.rankingPersonsAttendaces[row].attendanceNumber < 2 || self.rankingPersonsAttendaces[row].admonishmentNumber >= 2
            ? UIColor.red.cgColor
            : Theme.customGreen.cgColor
        }
    }
    
    func sortDescendingAttendanceFirstTime() {
        self.sorting = SortingPositionAndType(.attendance, .descending)
        self.rankingPersonsAttendaces =  self.rankingPersonsAttendaces.sorted { $0.attendanceNumber > $1.attendanceNumber }
        self.header[0] = self.headerBasic[0]
        self.header[1] = self.headerBasic[1] + " " + self.sorting.sortingType.symbol
        self.header[2] = self.headerBasic[2]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func rankingSectionHeaderView(_ cell: RankingSectionHeaderView, didSelectLabel number: Int) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        self.handleSorting(column: number)
    }
    
    func handleSorting(column: Int) {
        
        let oldSorting = self.sorting
        switch column {
        case 0: // Name
            // I want to sort in ascending when the oldSorting was name and descending or if i switch from another sortPosition
            if oldSorting.sortingType == .descending {
                self.rankingPersonsAttendaces =  self.rankingPersonsAttendaces.sorted{ $0.person.name ?? "" < $1.person.name ?? "" }
                self.sorting.sortingType = .ascending
            } else { // I want to sort in descending
                self.rankingPersonsAttendaces =  self.rankingPersonsAttendaces.sorted { $0.person.name ?? "" > $1.person.name ?? "" }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[1] = self.headerBasic[1]
            self.header[2] = self.headerBasic[2]
            self.sorting.sortingPosition = .name
        case 1: // Attendacne
            if oldSorting.sortingType == .descending {
                self.rankingPersonsAttendaces =  self.rankingPersonsAttendaces.sorted { $0.attendanceNumber < $1.attendanceNumber }
                self.sorting.sortingType = .ascending
            } else {
                self.rankingPersonsAttendaces =  self.rankingPersonsAttendaces.sorted { $0.attendanceNumber > $1.attendanceNumber }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[0] = self.headerBasic[0]
            self.header[2] = self.headerBasic[2]
            self.sorting.sortingPosition = .attendance
        case 2: // Admonishment
            if oldSorting.sortingType == .descending  {
                self.rankingPersonsAttendaces =  self.rankingPersonsAttendaces.sorted { $0.admonishmentNumber < $1.admonishmentNumber }
                self.sorting.sortingType = .ascending
            } else {
                self.rankingPersonsAttendaces =  self.rankingPersonsAttendaces.sorted { $0.admonishmentNumber > $1.admonishmentNumber }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[0] = self.headerBasic[0]
            self.header[1] = self.headerBasic[1]
            self.sorting.sortingPosition = .admonishment
        default: return
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


public class SortingPositionAndType {
    
    var sortingPosition: SortingPosition
    var sortingType: SortingType
    
    init(_ sortingPosition: SortingPosition, _ sortingType: SortingType) {
        self.sortingPosition = sortingPosition
        self.sortingType = sortingType
    }
}


public enum SortingPosition: Int {
    case name = 0
    case attendance = 1
    case admonishment = 2
}

public enum SortingType {
    case ascending
    case descending
    
    var symbol: String {
        switch self {
        case .ascending: // Freccia verso l'alto
            return "\u{25B2}"
        case .descending: // Freccia verso il basso
            return "\u{25BC}"
        }
    }
}
