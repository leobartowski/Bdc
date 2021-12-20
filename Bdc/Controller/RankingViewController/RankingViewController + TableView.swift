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

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return rankingPersonsAttendaces.count
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == selectedCellRow ? 200 : 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? RankingTableViewCell
        let rankingAttendance = rankingPersonsAttendaces[indexPath.row]
        cell?.setUp(rankingAttendance, indexPath)
        cell?.setupLabelDesign(sorting.sortingPosition.rawValue)
        handleColorOfTheCellOnFriday(cell, indexPath.row)
        cell?.setNeedsLayout()
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
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
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt _: IndexPath) {
        tableView.beginUpdates()
        UIView.animate(withDuration: 0.3) {
            tableView.performBatchUpdates(nil)
        }
        tableView.endUpdates()
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let sectionHeaderView = RankingSectionHeaderView()
        sectionHeaderView.delegate = self
        sectionHeaderView.nameLabel.text = header[0]
        sectionHeaderView.attendanceLabel.text = header[1]
        sectionHeaderView.admonishmentLabel.text = header[2]
        sectionHeaderView.setupLabelDesign(sorting.sortingPosition.rawValue)
        return sectionHeaderView
    }

    func tableViewSetup() {
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped))
        leftSwipeGR.direction = .left
        tableView.addGestureRecognizer(leftSwipeGR)

        let rightSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(tableViewSwiped))
        rightSwipeGR.direction = .right
        tableView.addGestureRecognizer(rightSwipeGR)

        header = headerBasic
    }

    func handleColorOfTheCellOnFriday(_ cell: RankingTableViewCell?, _ row: Int) {
        // Show red and green cell only on friday and only if the week on focus is the current week
        if Date().getDayNumberOfWeek() == 6, calendarView.currentPage.getWeekNumber() == Date.now.getWeekNumber() {
            // Check if the user has at least two presence or more than 2 admonishment
            cell?.containerView.layer.shadowOpacity = 0.7
            cell?.containerView.layer.shadowColor = rankingPersonsAttendaces[row].attendanceNumber < 2 || rankingPersonsAttendaces[row].admonishmentNumber >= 2
                ? UIColor.red.cgColor
                : Theme.customGreen.cgColor
        }
    }

    func sortDescendingAttendanceFirstTime() {
        sorting = SortingPositionAndType(.attendance, .descending)
        rankingPersonsAttendaces = rankingPersonsAttendaces.sorted { $0.attendanceNumber > $1.attendanceNumber }
        header[0] = headerBasic[0]
        header[1] = headerBasic[1] + " " + sorting.sortingType.symbol
        header[2] = headerBasic[2]
        selectedCellRow = -1
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func rankingSectionHeaderView(_: RankingSectionHeaderView, didSelectLabel number: Int) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        handleSorting(column: number)
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
            if oldSorting.sortingType == .descending {
                rankingPersonsAttendaces = rankingPersonsAttendaces.sorted { $0.attendanceNumber < $1.attendanceNumber }
                sorting.sortingType = .ascending
            } else {
                rankingPersonsAttendaces = rankingPersonsAttendaces.sorted { $0.attendanceNumber > $1.attendanceNumber }
                sorting.sortingType = .descending
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
        selectedCellRow = -1
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: Handle left or right swipe

    @objc func tableViewSwiped(sender: UISwipeGestureRecognizer) {
        let selectedDate = calendarView.selectedDate ?? Date.now
        if sender.direction == .right { // Right
            calendarView.setCurrentPage(selectedDate.previousWeek, animated: true)
        } else { // Left
            calendarView.setCurrentPage(selectedDate.nextWeek, animated: true)
        }
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
        feedbackGenerator.impactOccurred(intensity: 0.9)
    }
}
