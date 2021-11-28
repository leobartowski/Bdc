//
//  RankingTableViewCell + CollcetionView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 28/11/21.
//

import UIKit

extension RankingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daysCellID", for: indexPath) as? RankingSingleDayCollectionViewCell
        
        cell?.mainLabel.text = self.days[indexPath.item]
        
        // TODO: FIX, NOT WORKING
        if indexPath.section == 0 { // Morning
            if self.morningDaysNumbers.contains(indexPath.item + 2) {
                cell?.mainLabel.textColor = .black
            }
        } else { // Evening
            
            if self.eveningDaysNumbers.contains(indexPath.item + 2) {
                cell?.mainLabel.textColor = .black
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "rankingHeaderCVCellID",
                for: indexPath)
            
            guard let typedHeaderView = headerView as? RankingDayHeaderCollectionReusableView else { return headerView }
            typedHeaderView.titleLabel.text = indexPath.section == 0 ? "Mattina" : "Pomeriggio"

            return typedHeaderView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    
    
}
