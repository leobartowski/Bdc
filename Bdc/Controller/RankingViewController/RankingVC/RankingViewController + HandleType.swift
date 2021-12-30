//
//  RankingViewController + BottomSheet.swift
//  Bdc
//
//  Created by leobartowski on 21/12/21.
//

import Foundation
import UIKit
import FittedSheets

extension RankingViewController {
    
    func presentModalToChangeRankingType() {
        
        let storyBoard = UIStoryboard(name: "BottomSheet", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "rankingTypeID") as? RankingTypeViewController {
            // Set starting ranking type (when first opening is always weekly)
            vc.selectedType = self.rankingType
            let sheetController = SheetViewController(
                controller: vc,
                sizes: [.fixed(310)]
            )
            sheetController.gripSize = CGSize(width: 35, height: 6)
            
            sheetController.shouldDismiss = { _ in
                // Update rankingType based on user's choice
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RankingTypeTableViewCell {
                    
                    let oldRankingType = self.rankingType
                    cell.rankingType = vc.selectedType
                    self.rankingType = vc.selectedType
                    cell.handleChangeRankingType(oldRankingType)
                    
                }
                return true
            }
            self.present(sheetController, animated: true, completion: nil)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}
