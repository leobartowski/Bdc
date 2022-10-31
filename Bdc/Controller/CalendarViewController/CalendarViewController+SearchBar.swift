//
//  CalendarViewController+SearchBar.swift
//  Bdc
//
//  Created by leobartowski on 31/10/22.
//

import Foundation
import UIKit

extension CalendarViewController: UISearchBarDelegate {
    
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
        
        if let cvLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            cvLayout.sectionHeadersPinToVisibleBounds = true
        }
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
    
}
