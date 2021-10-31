//
//  RankingViewController + SpredSheet.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import SpreadsheetView

extension RankingViewController: SpreadsheetViewDelegate, SpreadsheetViewDataSource, HeaderCellDelegate {
        
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return self.weeklyAttendance.count + 1 // The first row is for the labels
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        let firstColumn: CGFloat = 160
        let otherColumn: CGFloat = ((self.view.frame.width - firstColumn) / 2) - 2
        return column == 0 ? firstColumn : otherColumn
        
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return row == 0 ? 40 : 60
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.row == 0 { // Header Row
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as? HeaderCell
            cell?.setUp(indexPath.column, self)
            cell?.label.text = self.header[indexPath.column]
            cell?.setNeedsLayout()
            
            return cell ?? Cell()
        } else {
            if indexPath.column == 0 { // NameCell
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: NameCell.self), for: indexPath) as? NameCell
                let person = self.weeklyAttendance[indexPath.row - 1].person
                cell?.label.text = person.name ?? ""
                let imageString = CommonUtility.getProfileImageString(person)
                cell?.imageView.image = UIImage(named: imageString)
                cell?.setNeedsLayout()
                cell?.setNeedsLayout()
                return cell ?? Cell()
            } else {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as? TextCell
                if indexPath.column == 1 {
                    cell?.label.text = String(self.weeklyAttendance[indexPath.row - 1].attendanceNumber)
                } else if indexPath.column == 2 {
                    cell?.label.text = String(self.weeklyAttendance[indexPath.row - 1].admonishmentNumber)
                }
                return cell ?? Cell()
            }

        }
    }
    
    // MARK: HeaderCellDelegate
    func headerCell(_ cell: HeaderCell, didSelectRowAt column: Int) {
        cell.label.text = header[column]
        switch column {
        case 0:
            self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.person.name ?? "" < $1.person.name ?? "" }
            cell.label.text = header[column] + Sorting.ascending.symbol
        case 1:
            self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.attendanceNumber > $1.attendanceNumber}
            cell.label.text = header[column] + Sorting.ascending.symbol
        case 2:
            self.weeklyAttendance =  self.weeklyAttendance.sorted {$0.attendanceNumber > $1.attendanceNumber}
            cell.label.text = header[column] + Sorting.ascending.symbol
        default: return
        }
        DispatchQueue.main.async {
            self.spreadsheetView.reloadData()
        }
    }
    
    func handleColorOfTheCellOnFriday(_ cell: Cell?, _ row: Int) {
        // Show red and green cell only on friday and only if the week on focus is the current week
        if Date().getDayNumberOfWeek() == 6 && self.calendarView.currentPage.getWeekNumber() == Date.now.getWeekNumber() {
            // Check if the user has at least two presence or more than 2 admonishment
            cell?.backgroundColor = self.weeklyAttendance[row - 1].attendanceNumber < 2 || self.weeklyAttendance[row - 1].admonishmentNumber >= 2
            ? Theme.customRed
            : Theme.customGreen
        }
    }
    
}
