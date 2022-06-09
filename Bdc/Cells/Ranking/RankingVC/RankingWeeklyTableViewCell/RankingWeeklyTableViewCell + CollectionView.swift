//
//  RankingTableViewCell + CollcetionView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 28/11/21.
//

import UIKit

extension RankingWeeklyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daysCellID", for: indexPath) as? RankingSingleDayCollectionViewCell

        cell?.mainLabel.text = days[indexPath.item]
        
        if self.holidayDaysNumbers.contains(indexPath.item + 2) { // This day is Holiday
            cell?.setupForHoliday()
        } else { // This day is not holiday

            if indexPath.section == 0 { // Morning
                
                if self.morningDaysNumbers.contains(indexPath.item + 2) { // isPresent
                    cell?.setupIfPresent()
                } else if self.morningDaysAdmonishmentNumbers.contains(indexPath.item + 2) { // isAdminished
                    cell?.setupIfAdmonished()
                }
                
            } else { // Evening
                
                if self.eveningDaysNumbers.contains(indexPath.item + 2) { // isPresent
                    cell?.setupIfPresent()
                } else if self.eveningDaysAdmonishmentNumbers.contains(indexPath.item + 2) { // isAdminished
                    cell?.setupIfAdmonished()
                }
            }
        }
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "rankingHeaderCVCellID",
                for: indexPath
            )

            guard let typedHeaderView = headerView as? RankingDayHeaderCollectionReusableView else { return headerView }
            typedHeaderView.titleLabel.text = indexPath.section == 0 ? "Mattina" : "Sera"

            return typedHeaderView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    
}
