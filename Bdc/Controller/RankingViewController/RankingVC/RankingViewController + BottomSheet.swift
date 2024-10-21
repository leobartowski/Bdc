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
                sizes: [.fixed(431)],
                options: SheetOptions(shrinkPresentingViewController: false)
            )
            sheetController.gripColor = .systemGray
            sheetController.gripSize = CGSize(width: 35, height: 6)
            sheetController.shouldDismiss = { _ in
                if vc.selectedType != self.rankingType {
                    self.showLoader()
                }
                return true
            }
            sheetController.didDismiss = { _ in
                if vc.selectedType == self.rankingType {
                    return
                }
                self.rankingType = vc.selectedType
                self.handleChangeRankingType()
            }
            
            self.present(sheetController, animated: true, completion: nil)
            // I have no idea where this -143 came from but it works
            self.tableView.setContentOffset(CGPoint(x: 0, y: -143), animated: true)
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
            sheetController.gripColor = .systemGray
            sheetController.gripSize = CGSize(width: 35, height: 6)
            sheetController.shouldDismiss = { _ in
                if vc.selectedSlot != self.slotType {
                    self.showLoader()
                }
                return true
            }
            sheetController.didDismiss = { _ in
                if vc.selectedSlot == self.slotType {
                    return
                }
                self.slotType = vc.selectedSlot
                self.setupSlotLabel()
                self.populateAttendance()
            }
            self.present(sheetController, animated: true, completion: nil)
            self.tableView.setContentOffset(CGPoint(x: 0, y: -143), animated: true)
        }
    }
    
}
