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
    
    func spreadsheetView(_ spreadshe5tView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        let firstColumn: CGFloat = 160
        let otherColumn: CGFloat = (((self.view.frame.width - 20) - firstColumn) / 2) 
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
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderSpreadSheetCell.self), for: indexPath) as? HeaderSpreadSheetCell
            cell?.setUp(indexPath.column, self.header[indexPath.column], self)
            cell?.setNeedsLayout()
            return cell ?? Cell()
        } else { // All the other Rows
            
            if indexPath.column == 0 { // NameCell
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: NameSpreadSheetCell.self), for: indexPath) as? NameSpreadSheetCell
                let person = self.weeklyAttendance[indexPath.row - 1].person
                cell?.setUp(person)
                self.handleColorOfTheCellOnFriday(cell, indexPath.row)
                cell?.setNeedsLayout()
                return cell ?? Cell()
            } else { // Presence cell and Admonishment cell
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextSpreadSheetCell.self), for: indexPath) as? TextSpreadSheetCell
                let text = indexPath.column == 1
                ? String(self.weeklyAttendance[indexPath.row - 1].attendanceNumber)
                : String(self.weeklyAttendance[indexPath.row - 1].admonishmentNumber)
                cell?.setUp(indexPath.column, text)
                self.handleColorOfTheCellOnFriday(cell, indexPath.row)
                cell?.setNeedsLayout()
                return cell ?? Cell()
            }
        }
    }
    
    // MARK: HeaderCellDelegate
    func headerCell(_ cell: HeaderSpreadSheetCell, didSelectRowAt column: Int) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        self.handleSorting(column: column)
    }
    
    func handleColorOfTheCellOnFriday(_ cell: Cell?, _ row: Int) {
        // Show red and green cell only on friday and only if the week on focus is the current week
        if Date().getDayNumberOfWeek() == 6 && self.calendarView.currentPage.getWeekNumber() == Date.now.getWeekNumber() {
            // Check if the user has at least two presence or more than 2 admonishment
            cell?.backgroundColor = self.weeklyAttendance[row - 1].attendanceNumber < 2 || self.weeklyAttendance[row - 1].admonishmentNumber >= 2
            ? Theme.customMediumRed
            : Theme.customMediumGreen
        }
    }b
    
    // MARK: SpreadSheet SetUp
//    func spreadSheetSetup() {
//        self.header = self.headerBasic
//        self.spreadsheetView.backgroundColor = Theme.dirtyWhite
//        self.spreadsheetView.dataSource = self
//        self.spreadsheetView.delegate = self
//        self.spreadsheetView.bounces = false
//        self.spreadsheetView.intercellSpacing = CGSize(width: 0, height: 10)
//        self.spreadsheetView.gridStyle = .none
//        self.calendarView.today = nil // Removed today and changed the appearence in the delegate
//        self.spreadsheetView.showsVerticalScrollIndicator = false
//        self.spreadsheetView.showsHorizontalScrollIndicator = false
//        self.spreadsheetView.allowsSelection = false
//        self.spreadsheetView.register(HeaderSpreadSheetCell.self, forCellWithReuseIdentifier: String(describing: HeaderSpreadSheetCell.self))
//        self.spreadsheetView.register(TextSpreadSheetCell.self, forCellWithReuseIdentifier: String(describing: TextSpreadSheetCell.self))
//        self.spreadsheetView.register(NameSpreadSheetCell.self, forCellWithReuseIdentifier: String(describing: NameSpreadSheetCell.self))
//    }
    
    // TODO: Re-write this method
    func handleSorting(column: Int) {
        
        let oldSorting = self.sorting
        switch column {
        case 0: // Name
            // I want to sort in ascending when the oldSorting was name and descending or if i switch from another sortPosition
            if oldSorting.sortingType == .descending {
                self.weeklyAttendance =  self.weeklyAttendance.sorted{ $0.person.name ?? "" < $1.person.name ?? "" }
                self.sorting.sortingType = .ascending
            } else { // I want to sort in descending
                self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.person.name ?? "" > $1.person.name ?? "" }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[1] = self.headerBasic[1]
            self.header[2] = self.headerBasic[2]
        case 1: // Attendacne
            if oldSorting.sortingType == .descending {
                self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.attendanceNumber < $1.attendanceNumber }
                self.sorting.sortingType = .ascending
            } else {
                self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.attendanceNumber > $1.attendanceNumber }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[0] = self.headerBasic[0]
            self.header[2] = self.headerBasic[2]
        case 2: // Admonishment
            if oldSorting.sortingType == .descending  {
                self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.admonishmentNumber < $1.admonishmentNumber }
                self.sorting.sortingType = .ascending
            } else {
                self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.admonishmentNumber > $1.admonishmentNumber }
                self.sorting.sortingType = .descending
            }
            self.header[column] = self.headerBasic[column] + " " + self.sorting.sortingType.symbol
            self.header[0] = self.headerBasic[0]
            self.header[1] = self.headerBasic[1]
        default: return
        }
        DispatchQueue.main.async {
            self.spreadsheetView.reloadData()
        }
    }
    
    func sortDescendingAttendanceFirstTime() {
        self.sorting = SortingPositionAndType(.attendance, .descending)
        self.weeklyAttendance =  self.weeklyAttendance.sorted { $0.attendanceNumber > $1.attendanceNumber }
        self.header[0] = self.headerBasic[0]
        self.header[1] = self.headerBasic[1] + " " + self.sorting.sortingType.symbol
        self.header[2] = self.headerBasic[2]
        DispatchQueue.main.async {
            self.spreadsheetView.reloadData()
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
