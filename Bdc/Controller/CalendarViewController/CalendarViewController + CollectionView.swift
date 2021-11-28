//
//  CalendarViewController + CollectionView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, CalendarCollectionViewCellDelegate {

    
    // MARK: Delegate e DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.personsPresent.count : self.personsNotPresent.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presentCellID", for: indexPath) as? CalendarCollectionViewCell
        if indexPath.section == 0 {
            cell?.setUp(self.personsPresent[indexPath.row], false, indexPath, self)
        } else {
            let personNotPresent = self.personsNotPresent[indexPath.row]
            let isAmonished = self.personsAdmonished.contains(where: { $0.name == personNotPresent.name })
            cell?.setUp(personNotPresent, isAmonished, indexPath, self)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check to avoid the modification of day older than today
        if Date().days(from: self.calendarView.selectedDate ?? Date()) > 0 {
            return
        }
        if indexPath.section == 0 { // Person Present
            let personToRemove = self.personsPresent[indexPath.row]
            self.personsPresent.remove(at: indexPath.row)
            self.personsNotPresent.append(personToRemove)
        } else { // Person not present
            let personToAdd = self.personsNotPresent[indexPath.row]
            if self.personsAdmonished.contains(where: { $0.name == personToAdd.name }) {
                self.presentAlert(alertText: "Errore", alertMessage: "Una persona ammonita non pùo risultate presente, rimuovi l'ammonizione e poi procedi ")
                return
            }
            self.personsNotPresent.remove(at: indexPath.row)
            self.personsPresent.append(personToAdd)
        }
        CoreDataService.shared.saveAttendance(self.calendarView.selectedDate ?? Date(), self.dayType, self.personsPresent)
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator.impactOccurred(intensity: 0.6)
        self.sortPersonPresentAndNot()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "sectionHeaderID",
                for: indexPath)
            
            guard let typedHeaderView = headerView as? CalendarHeaderCollectionReusableView else { return headerView }
            typedHeaderView.titleLabel.text = self.sectionTitles[indexPath.section]

            return typedHeaderView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView && self.calendarView.scope == .month &&
            self.collectionView.contentSize.height > 0 &&
            ((self.collectionView.contentOffset.y + self.collectionView.safeAreaInsets.top) <= 0) {

                self.handleMonthlyToWeeklyCalendar()
        }
    }
    
    //MARK: CalendarViewControllerCellDelegate
    
    func mainCell(_ cell: CalendarCollectionViewCell, didSelectRowAt indexPath: IndexPath) {
        // Check to avoid the modification of day older than today
        if Date().days(from: self.calendarView.selectedDate ?? Date()) > 0 {
            return
        }
        let personToHandle = self.personsNotPresent[indexPath.row]
        // I need to amonish this person if is not amonished or I need to remove the amonishment otherwise
        if let index = self.personsAdmonished.firstIndex(where: { $0.name == personToHandle.name}) {
            self.personsAdmonished.remove(at: index)
        } else {
            self.personsAdmonished.append(personToHandle)
        }
        CoreDataService.shared.saveAdmonishedAttendance(self.calendarView.selectedDate ?? Date(), self.dayType, self.personsAdmonished)

        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    // MARK: SetUp CollectionView
    // I don't know why but putting sectionHeadersPinToVisibleBounds = true create a streange glich
    // when the calendar change scope (week or month)
//    func setupCollectionView() {
//        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.sectionHeadersPinToVisibleBounds = true
//    }
}
