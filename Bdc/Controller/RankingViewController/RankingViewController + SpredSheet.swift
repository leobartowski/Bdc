//
//  RankingViewController + SpredSheet.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import Foundation
import SpreadsheetView

extension RankingViewController: SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return Utility.persons.count + 1
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        let firstColumn: CGFloat = 160
        let otherColumn: CGFloat = ((self.view.frame.width - firstColumn) / 2) - 2
        return column == 0 ? firstColumn : otherColumn
        
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
      return 50
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.row == 0 {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = self.header[indexPath.column]

            if case indexPath.column = self.sortedColumn.column {
                cell.sortArrow.text = self.sortedColumn.sorting.symbol
            } else {
                cell.sortArrow.text = ""
            }
            cell.setNeedsLayout()
            
            return cell
        } else {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text = self.data[indexPath.row - 1][indexPath.column]
            return cell
        }
    }

}
