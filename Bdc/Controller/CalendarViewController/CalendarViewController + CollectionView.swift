//
//  CalendarViewController + CollectionView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CalendarCollectionViewCellDelegate {
    
    // MARK: Delegate e DataSource

    func numberOfSections(in _: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0
            ? personsPresent.isEmpty ? 1 : personsPresent.count
            : personsNotPresent.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0, personsPresent.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeholderID", for: indexPath)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presentCellID", for: indexPath) as? CalendarCollectionViewCell
        if indexPath.section == 0 {
            cell?.setUp(personsPresent[indexPath.row], false, indexPath, self)
        } else {
            let personNotPresent = personsNotPresent[indexPath.row]
            let isAmonished = personsAdmonished.contains(where: { $0.name == personNotPresent.name })
            cell?.setUp(personNotPresent, isAmonished, indexPath, self)
        }
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // Check to avoid the modification of day older than today
        if ((Date().days(from: calendarView.selectedDate ?? Date()) > 0) && !self.canModifyOldDays) ||
            (indexPath.section == 0 && personsPresent.isEmpty) {
            return false
        }
        return true
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Person Present
            let personToRemove = personsPresent[indexPath.row]
            personsPresent.remove(at: indexPath.row)
            personsNotPresent.append(personToRemove)
        } else { // Person not present
            let personToAdd = personsNotPresent[indexPath.row]
            if personsAdmonished.contains(where: { $0.name == personToAdd.name }) {
                presentAlert(alertText: "Errore", alertMessage: "Una persona ammonita non pùo risultare presente, rimuovi l'ammonizione se vuoi mettere la presenza a \(personToAdd.name ?? "")")
                return
            }
            personsNotPresent.remove(at: indexPath.row)
            personsPresent.append(personToAdd)
        }
        CoreDataService.shared.saveAttendance(calendarView.selectedDate ?? Date(), dayType, personsPresent)
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator.impactOccurred(intensity: 0.6)
        sortPersonPresentAndNot()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.postNotificationUpdateAttendance()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "sectionHeaderID",
                for: indexPath
            )

            guard let typedHeaderView = headerView as? CalendarHeaderCollectionReusableView else { return headerView }
            typedHeaderView.titleLabel.text = sectionTitles[indexPath.section]

            return typedHeaderView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0, personsPresent.isEmpty {
            return CGSize(width: view.frame.width - 40, height: view.frame.height / 2.8)
        }
        return CGSize(width: 80, height: 100)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView,
           self.calendarView.scope == .month,
           self.collectionView.contentSize.height > 0,
           (self.collectionView.contentOffset.y + self.collectionView.safeAreaInsets.top) <= 0 {

            self.handleMonthlyToWeeklyCalendar()
        }
    }

    // MARK: CalendarViewControllerCellDelegate

    func mainCell(_: CalendarCollectionViewCell, didSelectRowAt indexPath: IndexPath) {
        // Check to avoid the modification of day older than today
        if ((Date().days(from: calendarView.selectedDate ?? Date()) > 0) && !self.canModifyOldDays) { return }
        let personToHandle = personsNotPresent[indexPath.row]
        // I need to amonish this person if is not amonished or I need to remove the amonishment otherwise
        if let index = personsAdmonished.firstIndex(where: { $0.name == personToHandle.name }) {
            personsAdmonished.remove(at: index)
        } else {
            personsAdmonished.append(personToHandle)
        }
        CoreDataService.shared.saveAdmonishedAttendance(calendarView.selectedDate ?? Date(), dayType, personsAdmonished)
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.postNotificationUpdateAttendance()
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
