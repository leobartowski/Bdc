//
//  RankingViewController + TableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 25/11/21.
//

import UIKit

extension RankingViewController: UITableViewDelegate, UITableViewDataSource, RankingSectionHeaderDelegate {
    
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankingPersonsAttendaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == self.selectedCellRow && self.rankingType == .weekly) ? 200 : 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.rankingType == .weekly {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weeklyCellID", for: indexPath) as? RankingWeeklyTableViewCell
            let rankingAttendance = rankingPersonsAttendaces[indexPath.row]
            if self.calculateIfShowConfetti(rankingAttendance) { self.startConfetti() }
            cell?.setUp(rankingAttendance, indexPath, self.rankingType, self.holidaysNumbers)
            cell?.setupLabelDesign(sorting.sortingPosition.rawValue)
            cell?.handleShadowOnFriday(self.daysCurrentPeriod.last?.getWeekNumber())
            cell?.setNeedsLayout()
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? RankingTableViewCell
            let rankingAttendance = rankingPersonsAttendaces[indexPath.row]
            cell?.setUp(rankingAttendance, indexPath, self.rankingType)
            cell?.setupLabelDesign(sorting.sortingPosition.rawValue)
            cell?.setNeedsLayout()
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.selectedCellRow = indexPath.row == self.selectedCellRow ? -1 : indexPath.row
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return indexPath }
        if selectedIndexPath == indexPath {
            tableView.beginUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
            UIView.animate(withDuration: 0.3) {
                tableView.performBatchUpdates(nil)
            }
            tableView.endUpdates()
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            tableView.performBatchUpdates(nil)
        }
        tableView.endUpdates()
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
        sectionHeaderView.setupLabelDesign(sorting.sortingPosition.rawValue)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableViewSetup() {
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(self.tableViewSwiped))
        leftSwipeGR.direction = .left
        self.tableView.addGestureRecognizer(leftSwipeGR)
        let rightSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(self.tableViewSwiped))
        rightSwipeGR.direction = .right
        self.tableView.addGestureRecognizer(rightSwipeGR)
        self.header = self.headerBasic
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 10))
    }
    
    func sortDescendingAttendanceFirstTime() {
        self.sorting = SortingPositionAndType(.attendance, .descending)
        self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted {
            if self.rankingType == .allTimePonderate {
                let weightedAttendance0 = Float($0.attendanceNumber) * $0.person.difficultyCoefficient
                let weightedAttendance1 = Float($1.attendanceNumber) * $1.person.difficultyCoefficient
                return weightedAttendance0 > weightedAttendance1
            } else {
                return $0.attendanceNumber > $1.attendanceNumber
            }
        }
        self.header[0] = self.headerBasic[0]
        self.header[1] = self.headerBasic[1] + " " + self.sorting.sortingType.symbol
        self.header[2] = self.headerBasic[2]
        self.customReloadTableView()
    }
    
    func createHoldayDatesNumberArrayIfNeeded() {
        self.holidaysNumbers = []
        if let allDates = self.daysCurrentPeriod.first?.getAllDatesOfTheWeek(), self.rankingType == .weekly {
            for date in allDates where date.isHoliday(in: .italy) {
                self.holidaysNumbers.append(date.getDayNumberOfWeek() ?? 1)
            }
        }
    }
    
    func rankingSectionHeaderView(_: RankingSectionHeaderView, didSelectLabel number: Int) {
        self.feedbackGenerator.impactOccurred()
        self.handleSorting(column: number)
    }
    
    func handleSorting(column: Int) {
        let oldSorting = sorting
        switch column {
        case 0: // Name
            // I want to sort in ascending when the oldSorting was name and descending or if i switch from another sortPosition
            if oldSorting.sortingType == .descending {
                rankingPersonsAttendaces = rankingPersonsAttendaces.sorted { $0.person.name ?? "" < $1.person.name ?? "" }
                sorting.sortingType = .ascending
            } else { // I want to sort in descending
                rankingPersonsAttendaces = rankingPersonsAttendaces.sorted { $0.person.name ?? "" > $1.person.name ?? "" }
                sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[1] = self.headerBasic[1]
            self.header[2] = self.headerBasic[2]
            self.sorting.sortingPosition = .name
        case 1: // Attendacne
            if oldSorting.sortingType == .descending {
                self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted {
                    if self.rankingType == .allTimePonderate {
                        let weightedAttendance0 = Float($0.attendanceNumber) * $0.person.difficultyCoefficient
                        let weightedAttendance1 = Float($1.attendanceNumber) * $1.person.difficultyCoefficient
                        return weightedAttendance0 < weightedAttendance1
                    } else {
                        return $0.attendanceNumber < $1.attendanceNumber
                    }
                }
                self.sorting.sortingType = .ascending
            } else {
                self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted {
                    if self.rankingType == .allTimePonderate {
                        let weightedAttendance0 = Float($0.attendanceNumber) * $0.person.difficultyCoefficient
                        let weightedAttendance1 = Float($1.attendanceNumber) * $1.person.difficultyCoefficient
                        return weightedAttendance0 > weightedAttendance1
                    } else {
                        return $0.attendanceNumber > $1.attendanceNumber
                    }
                }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + sorting.sortingType.symbol
            self.header[0] = self.headerBasic[0]
            self.header[2] = self.headerBasic[2]
            self.sorting.sortingPosition = .attendance
        case 2: // Admonishment
            if oldSorting.sortingType == .descending {
                self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted { $0.admonishmentNumber < $1.admonishmentNumber }
                self.sorting.sortingType = .ascending
            } else {
                self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted { $0.admonishmentNumber > $1.admonishmentNumber }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[0] = self.headerBasic[0]
            self.header[1] = self.headerBasic[1]
            self.sorting.sortingPosition = .admonishment
        default: return
        }
        self.customReloadTableView()
    }
    
    ///  Used to reload the table view section 1 to update the attendance
    func customReloadTableView() {
        if let confettiView, confettiView.isActive() {
            confettiView.stopConfetti()
        }
        // We need this temp var because to avoid a graphic glitch we need to use animation if there was a selected cell
        let previousSelectedRow = self.selectedCellRow
        self.selectedCellRow = -1
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: previousSelectedRow != -1 ? .automatic : .none)
        }
    }
    
    // MARK: Handle left or right swipe
    @objc func tableViewSwiped(sender: UISwipeGestureRecognizer) {
        if self.rankingType != .weekly { return }
        let selectedDate = self.calendarView.selectedDate ?? Date.now
        if sender.direction == .right {
            self.calendarView.setCurrentPage(selectedDate.previousWeek, animated: true)
        } else if sender.direction == .left { 
            self.calendarView.setCurrentPage(selectedDate.nextWeek, animated: true)
        }
        self.feedbackGenerator.impactOccurred(intensity: 0.5)
    }
}
