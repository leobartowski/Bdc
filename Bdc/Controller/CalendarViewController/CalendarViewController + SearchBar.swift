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
            return person.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
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
            self.collectionView.reloadData()
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
