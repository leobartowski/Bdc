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
        return 200
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return Utility.persons.count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
      return 80
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
      return 40
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    // MARK: Constrains
    // TODO: Understand why this fucking library doesn't work with storybaord
//    func spreadSheetSetUp(){
//        self.spreadSheetView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(self.spreadSheetView)
//        let margins = view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([
//            self.spreadSheetView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
//            self.spreadSheetView.topAnchor.constraint(equalTo: margins.topAnchor),
//            self.spreadSheetView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
//            self.spreadSheetView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
//        ])
//        self.spreadSheetView.delegate = self
//        self.spreadSheetView.dataSource = self
//    }
}
