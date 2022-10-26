//
//  CalendarViewController + CollectionView.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 19/11/21.
//

import Foundation
import UIKit

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CalendarCollectionViewCellDelegate, UISearchBarDelegate {
    
    // MARK: Delegate e DataSource
    func numberOfSections(in _: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : filteredPerson.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presentCellID", for: indexPath) as? CalendarCollectionViewCell
        let person = filteredPerson[indexPath.row]
        let isPresent = personsPresent.contains(where: { $0.name == person.name })
        let isAmonished = personsAdmonished.contains(where: { $0.name == person.name })
        cell?.setUp(person, isPresent, isAmonished, indexPath, self)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        // Check to avoid the modification of day older than today
        if ((Date().days(from: calendarView.selectedDate ?? Date()) > 0) && !self.canModifyOldDays) {
            return false
        }
        return true
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        let person = self.filteredPerson[indexPath.row]
        let isPresent = self.personsPresent.contains(where: { $0.name == person.name })
        if isPresent {
            self.personsPresent.removeAll(where: { $0.name == person.name })
        } else {
            if self.personsAdmonished.contains(where: { $0.name == person.name }) {
                self.presentAlert(alertText: "Errore", alertMessage: "Una persona ammonita non pùo risultare presente, rimuovi l'ammonizione se vuoi mettere la presenza a \(person.name ?? "")")
                return
            }
            self.personsPresent.append(person)
        }
        DispatchQueue.main.async {
            CoreDataService.shared.saveAttendance(self.calendarView.selectedDate ?? Date(), self.dayType, self.personsPresent)
        }
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator.impactOccurred(intensity: 0.6)
        self.sortPersonPresentAndNot()
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
            self.postNotificationUpdateAttendance()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 { return UICollectionReusableView() }
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "sectionHeaderID",
                for: indexPath
            )
            guard let typedHeaderView = headerView as? CalendarHeaderCollectionReusableView else { return headerView }
            typedHeaderView.searchBar.delegate = self
            self.searchBar = typedHeaderView.searchBar
            return typedHeaderView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 { return CGSize.zero }
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 { return CGSize.zero }
        return CGSize(width: 80, height: 100)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView,
           self.calendarView.scope == .month,
           self.collectionView.contentSize.height > 0,
           (self.collectionView.contentOffset.y + self.collectionView.safeAreaInsets.top) <= 0 {
            
            self.handleMonthlyToWeeklyCalendar()
        }
        if scrollView == self.collectionView,
           self.searchBar?.searchTextField.isEditing ?? true {
            self.searchBar?.endEditing(true)
        }
    }
    
    // MARK: CalendarViewControllerCellDelegate
    
    func mainCell(_: CalendarCollectionViewCell, didSelectRowAt indexPath: IndexPath) {
        
        // Check to avoid the modification of day older than today
        if ((Date().days(from: self.calendarView.selectedDate ?? Date()) > 0) && !self.canModifyOldDays) { return }
        let personToHandle = self.filteredPerson[indexPath.row]
        // I need to amonish this person if is not amonished or I need to remove the amonishment otherwise
        if let index = self.personsAdmonished.firstIndex(where: { $0.name == personToHandle.name }) {
            self.personsAdmonished.remove(at: index)
        } else {
            self.personsAdmonished.append(personToHandle)
        }
        DispatchQueue.main.async {
            CoreDataService.shared.saveAdmonishedAttendance(self.calendarView.selectedDate ?? Date(), self.dayType, self.personsAdmonished)
        }
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
            self.postNotificationUpdateAttendance()
        }
    }
    
    // MARK: SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredPerson = searchText.isEmpty ? self.allPersons : self.allPersons.filter { (person: Person) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return person.name!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        UIView.performWithoutAnimation {
            self.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.filteredPerson = self.allPersons
        UIView.performWithoutAnimation {
            self.collectionView.reloadSections(IndexSet(integer: 1))
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    // MARK: SetUp CollectionView
    
    // I don't know why but putting sectionHeadersPinToVisibleBounds = true create a streange glich
    // when the calendar change scope (week or month)
    //    func setupCollectionView() {
    //        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    //        layout?.sectionHeadersPinToVisibleBounds = true
    //    }
}
