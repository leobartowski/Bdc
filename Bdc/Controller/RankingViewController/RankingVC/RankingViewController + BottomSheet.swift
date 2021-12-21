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
        
            let vc = RankingTypeViewController()
            let nav = UINavigationController(rootViewController: vc)
            // 1
            nav.modalPresentationStyle = .pageSheet

            
            // 2
            if let sheet = nav.sheetPresentationController {

                // 3
                sheet.detents = [.medium()]

            }
            // 4
            present(nav, animated: true, completion: nil)

        }
    
}
