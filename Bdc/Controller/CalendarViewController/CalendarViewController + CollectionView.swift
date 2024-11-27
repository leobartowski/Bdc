//
//  CalendarViewController + CollectionView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CalendarCollectionViewCellDelegate {
    
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPerson.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.allPersons.count == self.filteredPerson.count
        ? CGSize(width: self.view.frame.width, height: 40)
        : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presentCellID", for: indexPath) as? CalendarCollectionViewCell
        let person = filteredPerson[indexPath.row]
        let isPresent = personsPresent.contains(where: { $0.name == person.name })
        let isAmonished = personsAdmonished.contains(where: { $0.name == person.name })
        cell?.setUp(person, isPresent, isAmonished, indexPath, self)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let selectedDate = Date().days(from: calendarView.selectedDate ?? Date())
        if selectedDate > 0 && !self.canModifyOldDays {
            return false
        }
        return true
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
        cell?.isUpdating = true
        let person = self.filteredPerson[indexPath.row]
        let isPresent = self.personsPresent.contains(where: { $0.name == person.name })
        if isPresent {
            self.personsPresent.removeAll(where: { $0.name == person.name })
        } else {
            if self.personsAdmonished.contains(where: { $0.name == person.name }) {
                self.presentAlert(alertText: "Errore", alertMessage: "Una persona ammonita non può risultare presente, rimuovi l'ammonizione per dare la presenza a \(person.name ?? "")")
                cell?.isUpdating = false
                return
            }
            self.personsPresent.append(person)
        }
        DispatchQueue.main.async {
            self.feedbackGenerator.impactOccurred(intensity: 0.6)
            CoreDataService.shared.saveAttendance(&self.selectedAttendance, self.calendarView.selectedDate ?? Date(), self.dayType, self.personsPresent)
            self.postNotificationUpdateAttendance()
            self.collectionView.reloadItems(at: [indexPath])
            self.updateFooter()
        }
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerID", for: indexPath) as? CalendarFooterCollectionReusableView
            footerView?.updateLabel(self.personsPresent.count, self.personsAdmonished.count)
            return footerView ?? UICollectionReusableView()
            
        }
        return UICollectionReusableView()
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
        let selectedDate = Date().days(from: self.calendarView.selectedDate ?? Date())
        if selectedDate > 0 && !self.canModifyOldDays { return }
        let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
        cell?.isUpdating = true
        let personToHandle = self.filteredPerson[indexPath.row]
        // I need to amonish this person if is not amonished or I need toz remove the amonishment otherwise
        if let index = self.personsAdmonished.firstIndex(where: { $0.name == personToHandle.name }) {
            self.personsAdmonished.remove(at: index)
        } else {
            if !self.personsPresent.contains(where: { $0.name == personToHandle.name }) {
                self.personsAdmonished.append(personToHandle)
            } else {
                self.presentAlert(alertText: "Errore", alertMessage: "Una persona presente non può essere ammonita, rimuovi la presenza per ammonire \(personToHandle.name ?? "") ")
                cell?.isUpdating = false
                return
            }
        }
        DispatchQueue.main.async {
            self.feedbackGenerator.impactOccurred()
            CoreDataService.shared.saveAdmonishedAttendance(&self.selectedAttendance,
                                                            self.calendarView.selectedDate ?? Date(),
                                                            self.dayType,
                                                            self.personsAdmonished)
            self.postNotificationUpdateAttendance()
            self.collectionView.reloadItems(at: [indexPath])
            self.updateFooter()
        }
    }
    
    private func updateFooter() {
        if let footer = self.collectionView
            .visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter)
            .first as? CalendarFooterCollectionReusableView {
            footer.updateLabel(self.personsPresent.count, self.personsAdmonished.count)
        }
    }

}
