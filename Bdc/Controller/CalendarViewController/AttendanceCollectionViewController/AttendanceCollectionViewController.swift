//
//  AttendanceCollectionViewController.swift
//  Bdc
//
//  Created by leobartowski on 28/10/22.
//

import UIKit

class AttendanceCollectionViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allPersons = PersonListUtility.persons
    var filteredPerson: [Person] = []
    var personsAdmonished: [Person] = []
    var personsPresent: [Person] = []
    var canModifyOldDays = false
    var calendarViewController: CalendarViewController!
    override var prefersStatusBarHidden: Bool { true }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCalendarVC()
        self.setUpSearchBar()
        self.addObservers()
        self.getDataFromCoreDataAndReloadViews()
        self.canModifyOldDays = UserDefaults.standard.bool(forKey: "modifyOldDays")
    }
    
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cerca..."
        self.navigationItem.searchController = searchController
    }
    
    private func getCalendarVC() {
        if let navigationController = self.parent as? UINavigationController,
           let parentVC = navigationController.parent as? CalendarViewController {
            self.calendarViewController = parentVC
        }
    }
    
    // MARK: Functions to fetch and save CoreData
    
    /// Update Presence reloading data from CoreData
    func getDataFromCoreDataAndReloadViews() {
        self.filteredPerson.removeAll()
        self.personsAdmonished.removeAll()
        self.personsPresent.removeAll()
        let attendance = CoreDataService.shared.getAttendace(
            self.calendarViewController.calendarView.selectedDate ?? Date.now,
            type: self.calendarViewController.dayType)
        self.personsPresent = attendance?.persons?.allObjects as? [Person] ?? []
        self.personsAdmonished = attendance?.personsAdmonished?.allObjects as? [Person] ?? []
        self.allPersons = PersonListUtility.persons
        self.filteredPerson = self.allPersons
        self.sortPersonPresentAndNot()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    // TODO: Improve sorting
    func sortPersonPresentAndNot() {
        self.allPersons = self.allPersons.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    // MARK: Handle settings
    @objc func didChangeModifyStatus(_: Notification) {
        self.canModifyOldDays = UserDefaults.standard.bool(forKey: "modifyOldDays")
    }
    
    // MARK: Handle settings
    @objc func didChangePersonList(_: Notification) {
        self.getDataFromCoreDataAndReloadViews()
    }
    
    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeModifyStatus(_:)), name: .didChangeModifyStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangePersonList(_:)), name: .didChangePersonList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    func postNotificationUpdateAttendance() {
        let notification = Notification(name: .didUpdateAttendance, object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            self.collectionView.contentInset = .zero
        } else {
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        self.collectionView.scrollIndicatorInsets = collectionView.contentInset
    }



}
