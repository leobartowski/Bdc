//
//  RankingViewController + BottomSheet.swift
//  Bdc
//
//  Created by leobartowski on 21/12/21.
//

import Foundation
import UIKit

extension RankingViewController {
    
    func presentModalToChangeRankingType() {
        
        let storyBoard = UIStoryboard(name: "BottomSheet", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "rankingTypeID") as? RankingTypeViewController {
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .pageSheet
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            self.present(navigationController, animated: true, completion: nil)
        }
        
    }
    
}
