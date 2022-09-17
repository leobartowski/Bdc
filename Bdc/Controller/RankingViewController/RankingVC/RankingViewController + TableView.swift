//
//  RankingViewController + TableView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 25/11/21.
//

import UIKit

extension RankingViewController: UITableViewDelegate, UITableViewDataSource, RankingSectionHeaderDelegate {
    
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : self.rankingPersonsAttendaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0
        ? indexPath.row == 0 ? 140 : 44
        : (indexPath.row == self.selectedCellRow && self.rankingType == .weekly) ? 200 : 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "rankingTypeCellID", for: indexPath) as? RankingTypeTableViewCell
                cell?.setup(self)
                return cell ?? UITableViewCell()
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "slotTypeCellID", for: indexPath) as? RankingSlotTypeTableViewCell
                cell?.setup(self.slotType)
                return cell ?? UITableViewCell()
            }

        } else {
            if self.rankingType == .weekly {
                let cell = tableView.dequeueReusableCell(withIdentifier: "weeklyCellID", for: indexPath) as? RankingWeeklyTableViewCell
                let rankingAttendance = rankingPersonsAttendaces[indexPath.row]
                if self.calculateIfShowConfetti(rankingAttendance) { self.confettiView?.startConfetti() }
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
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            selectedCellRow = indexPath.row == selectedCellRow ? -1 : indexPath.row
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
        
        return section == 0 ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let sectionHeaderView = RankingSectionHeaderView()
        sectionHeaderView.delegate = self
        sectionHeaderView.nameLabel.text = header[0]
        sectionHeaderView.attendanceLabel.text = header[1]
        sectionHeaderView.admonishmentLabel.text = header[2]
        sectionHeaderView.setupLabelDesign(sorting.sortingPosition.rawValue)
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
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
        sorting = SortingPositionAndType(.attendance, .descending)
        let isWeightedAttendance = UserDefaults.standard.bool(forKey: "weightedAttendance")
        self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted {
            if !isWeightedAttendance && self.rankingType != .weekly {
                return $0.attendanceNumber > $1.attendanceNumber
            } else {
                
                let weightedAttendance0 = Float($0.attendanceNumber) * $0.person.difficultyCoefficient
                let weightedAttendance1 = Float($1.attendanceNumber) * $1.person.difficultyCoefficient
                return weightedAttendance0 > weightedAttendance1
            }
        }
        header[0] = headerBasic[0]
        header[1] = headerBasic[1] + " " + sorting.sortingType.symbol
        header[2] = headerBasic[2]
        self.customReloadTableView()
    }
    
    func createHoldayDatesNumberArrayIfNeeded() {
        self.holidaysNumbers = []
        if let allDates = self.daysCurrentPeriod.first?.getAllDatesOfTheWeek(), self.rankingType == .weekly {
            for date in allDates {
                if date.isHoliday(in: .italy) {
                    self.holidaysNumbers.append(date.getDayNumberOfWeek() ?? 1)
                }
            }
        }
    }
    
    func rankingSectionHeaderView(_: RankingSectionHeaderView, didSelectLabel number: Int) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
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
            header[column] = headerBasic[column] + " " + sorting.sortingType.symbol
            header[1] = headerBasic[1]
            header[2] = headerBasic[2]
            sorting.sortingPosition = .name
        case 1: // Attendacne
            let isWeightedAttendance = UserDefaults.standard.bool(forKey: "weightedAttendance")
            if oldSorting.sortingType == .descending {
                self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted {
                    if !isWeightedAttendance && self.rankingType != .weekly {
                        return $0.attendanceNumber < $1.attendanceNumber
                    } else {
                        
                        let weightedAttendance0 = Float($0.attendanceNumber) * $0.person.difficultyCoefficient
                        let weightedAttendance1 = Float($1.attendanceNumber) * $1.person.difficultyCoefficient
                        return weightedAttendance0 < weightedAttendance1
                    }
                }
                self.sorting.sortingType = .ascending
            } else {
                self.rankingPersonsAttendaces = self.rankingPersonsAttendaces.sorted {
                    if !isWeightedAttendance && self.rankingType != .weekly {
                        return $0.attendanceNumber > $1.attendanceNumber
                    } else {
                        let weightedAttendance0 = Float($0.attendanceNumber) * $0.person.difficultyCoefficient
                        let weightedAttendance1 = Float($1.attendanceNumber) * $1.person.difficultyCoefficient
                        return weightedAttendance0 > weightedAttendance1
                    }
                }
                self.sorting.sortingType = .descending
            }
            header[column] = headerBasic[column] + " " + sorting.sortingType.symbol
            header[0] = headerBasic[0]
            header[2] = headerBasic[2]
            sorting.sortingPosition = .attendance
        case 2: // Admonishment
            if oldSorting.sortingType == .descending {
                rankingPersonsAttendaces = rankingPersonsAttendaces.sorted { $0.admonishmentNumber < $1.admonishmentNumber }
                sorting.sortingType = .ascending
            } else {
                rankingPersonsAttendaces = rankingPersonsAttendaces.sorted { $0.admonishmentNumber > $1.admonishmentNumber }
                sorting.sortingType = .descending
            }
            header[column] = headerBasic[column] + " " + sorting.sortingType.symbol
            header[0] = headerBasic[0]
            header[1] = headerBasic[1]
            sorting.sortingPosition = .admonishment
        default: return
        }
        self.customReloadTableView()
    }
    
    ///  Used to reload the table view section 1 to update the attendance
    func customReloadTableView() {
        // We need this temp var because to avoid a graphic glitch we need to use animation if there was a selected cell
        self.confettiView?.stopConfetti()
        let previousSelectedRow = self.selectedCellRow
        self.selectedCellRow = -1
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 1), with: previousSelectedRow != -1 ? .automatic : .none)
        }
    }
    
    // MARK: Handle left or right swipe
    
    @objc func tableViewSwiped(sender: UISwipeGestureRecognizer) {
        if self.rankingType != .weekly { return }
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RankingTypeTableViewCell {
            let selectedDate = cell.calendarView.selectedDate ?? Date.now
            if sender.direction == .right { // Right
                cell.calendarView.setCurrentPage(selectedDate.previousWeek, animated: true)
            } else { // Left
                cell.calendarView.setCurrentPage(selectedDate.nextWeek, animated: true)
            }
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
            feedbackGenerator.impactOccurred(intensity: 0.9)
        }
    }
}
