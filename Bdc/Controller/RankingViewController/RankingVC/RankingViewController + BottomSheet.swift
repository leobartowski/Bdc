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
                sizes: [.fixed(370)],
                options: SheetOptions(shrinkPresentingViewController: false)
            )
            sheetController.gripSize = CGSize(width: 35, height: 6)
            
            sheetController.shouldDismiss = { _ in
                // Update rankingType based on user's choice
                let oldRankingType = self.rankingType
                self.rankingType = vc.selectedType
                self.handleChangeRankingType(oldRankingType)
                return true
            }
            self.present(sheetController, animated: true, completion: nil)
            self.tableView.setContentOffset(CGPoint(x: 0, y: -150), animated: true)

        }
    }
    
    func presentModalToChangeSlotType() {
        
        let storyBoard = UIStoryboard(name: "BottomSheet", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "slotTypeID") as? SlotTypeViewController {
            // Set starting slot type (when first opening is always morning+evening)
            vc.selectedSlot = self.slotType
            let sheetController = SheetViewController(
                controller: vc,
                sizes: [.fixed(310)],
                options: SheetOptions(shrinkPresentingViewController: false)
            )
            sheetController.gripSize = CGSize(width: 35, height: 6)
            
            sheetController.shouldDismiss = { _ in
                // Update slotType based on user's choice
                self.slotType = vc.selectedSlot
                self.setupSlotLabel()
                self.populateAttendance()
                return true
            }
            self.present(sheetController, animated: true, completion: nil)
            self.tableView.setContentOffset(CGPoint(x: 0, y: -150), animated: true)
        }
    }

}
