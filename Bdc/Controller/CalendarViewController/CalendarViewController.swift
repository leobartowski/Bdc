//
//  ViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import FSCalendar
import UIKit
import SwiftHoliday

class CalendarViewController: UIViewController {
    
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentedControl: MySegmentedControl!
    @IBOutlet var bottomCalendarHandleView: UIView!
    @IBOutlet var goToTodayButton: UIButton!
    @IBOutlet var segmentedControlContainerView: UIView!
    @IBOutlet var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar! // Strong: it's a top level object in the storyboard, added to the collectionView in code

    var dayType = DayType.evening
    var allPersons = PersonListUtility.persons
    var selectedAttendance: Attendance?
    var filteredPerson: [Person] = []
    var personsAdmonished: [Person] = []
    var personsPresent: [Person] = []
    var canModifyOldDays = false
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    let searchBarHeight: CGFloat = 56
    /// Content offset that keeps the search bar hidden above the first row of the collectionView
    var searchBarHiddenOffset: CGPoint {
        return CGPoint(x: 0, y: self.searchBarHeight - self.collectionView.adjustedContentInset.top)
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCalendarAppearance()
        self.setupSegmentedControl()
        self.setupSearchBarInCollectionView()
        self.getDataFromCoreDataAndReloadViews()
        self.addCalendarGestureRecognizer()
        self.designBottomCalendarHandleView()
        self.setupGoToTodayButton()
        self.updateGoToTodayButton()
        self.addObservers()
        self.addSwipeGestureRecognizerToCollectionView()
        self.canModifyOldDays = UserDefaults.standard.bool(forKey: SettingsType.modifyOldDays.rawValue)
        self.searchBar.setValue("Annulla", forKey: "cancelButtonText")
        self.handleTraitChange()
    }
    
    @objc func willBecomeActive() {
        self.updateDayTypeBasedOnTime()
    }
    
    @objc func systemTimeChanged() {
        self.updateCalendarIfNeeded()
    }
    
    func handleTraitChange() {
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.calendarView.reloadData()
            }
        })
    }
    
    // MARK: Utils and Design
    /// Add shadow and corner radius to bottom Calendar Handle View
    func designBottomCalendarHandleView() {
        self.bottomCalendarHandleView.layer.cornerRadius = 13
        self.bottomCalendarHandleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.willBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeModifyStatus(_:)), name: .didChangeModifyStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangePersonList(_:)), name: .didChangePersonList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// The search bar lives above the first row of the collectionView: hidden at rest, revealed pulling the list down
    func setupSearchBarInCollectionView() {
        self.searchBar.frame = CGRect(x: 5, y: 0, width: self.collectionView.bounds.width - 10, height: self.searchBarHeight)
        self.searchBar.autoresizingMask = [.flexibleWidth]
        self.collectionView.addSubview(self.searchBar)
        let firstRowTopSpacing: CGFloat = 10
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.top += self.searchBarHeight + firstRowTopSpacing
    }

    func setupGoToTodayButton() {
        if #available(iOS 26, *) {
            var configuration = UIButton.Configuration.glass()
            configuration.image = UIImage(systemName: "calendar")?.withTintColor(Theme.main, renderingMode: .alwaysOriginal)
            self.goToTodayButton.configuration = configuration
        }
    }

    func updateGoToTodayButton() {
        self.goToTodayButton.alpha = Date().isThisDaySelectable() ? 1 : 0.3
    }
    
    func automaticScrollToToday() {
        DispatchQueue.main.async {
            self.calendarView.setCurrentPage(Constant.endingDateBdC, animated: true)
//            self.calendarView.setCurrentPage(Date.now, animated: true)
            self.calendarView.select(Constant.endingDateBdC)
//            self.calendarView.select(Date.now)
            self.getDataFromCoreDataAndReloadViews()
        }
    }
    
    func postNotificationUpdateAttendance() {
        let notification = Notification(name: .didUpdateAttendance, object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func setupSegmentedControl() {
        if #available(iOS 26, *) {
            self.segmentedControl.applyLiquidGlassStyle()
            return
        }
        self.segmentedControl.backgroundColor = Theme.contentBackground
        self.segmentedControl.borderColor = Theme.main
        self.segmentedControl.selectedSegmentTintColor = Theme.main
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: Theme.neutral]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: Theme.label]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }
    
    func reloadCalendarDateIfNeeded() {
        if self.calendarView.maximumDate < Constant.endingDateBdC {
            self.updateGoToTodayButton()
            self.calendarView.reloadData()
        }
    }
    
    // MARK: Functions to fetch and save CoreData
    
    /// Update Presence reloading data from CoreData
    func getDataFromCoreDataAndReloadViews() {
        self.filteredPerson.removeAll()
        self.personsAdmonished.removeAll()
        self.personsPresent.removeAll()
        self.selectedAttendance =  CoreDataService.shared.getAttendace(self.calendarView.selectedDate ?? Date.now, type: self.dayType)
        self.personsPresent = self.selectedAttendance?.persons?.allObjects as? [Person] ?? []
        self.personsAdmonished = self.selectedAttendance?.personsAdmonished?.allObjects as? [Person] ?? []
        self.allPersons = PersonListUtility.persons
        self.filteredPerson = self.allPersons
        self.sortPersons()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if !self.searchBar.isFirstResponder {
                // Content size must be ready, otherwise the collectionView clamps the offset back to the top
                self.collectionView.layoutIfNeeded()
                self.collectionView.setContentOffset(self.searchBarHiddenOffset, animated: true)
            }
        }
    }
    
    func sortPersons() {
        self.allPersons = self.allPersons.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    // MARK: Handle settings
    @objc func didChangeModifyStatus(_: Notification) {
        self.canModifyOldDays = UserDefaults.standard.bool(forKey: SettingsType.modifyOldDays.rawValue)
    }
    
    // MARK: Handle settings
    @objc func didChangePersonList(_: Notification) {
        self.getDataFromCoreDataAndReloadViews()
    }
    
    // MARK: IBActions
    
    @IBAction func segmentedControlValueChanged(_: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0: self.dayType = .morning
        case 1: self.dayType = .evening
        default: break
        }
        self.getDataFromCoreDataAndReloadViews()
    }
    
    @IBAction func goToTodayTouchUpInside(_: Any) {
        if !Date().isThisDaySelectable() {
            self.presentAlert(alertText: "Hey!", alertMessage: "Mi dispiace, ma dovresti sapere che oggi non si prendono presenze!")
        } else {
            self.automaticScrollToToday()
        }
    }
    
    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .up:
                self.handleMonthlyToWeeklyCalendar()
            case .down:
                self.handleWeeklyToMonthlyCalendar()
            default:
                break
            }
        }
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
        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset
    }
    
    // MARK: Selected Control
    func addSwipeGestureRecognizerToCollectionView() {
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(self.collectionViewSwiped))
        leftSwipeGR.direction = .left
        self.collectionView.addGestureRecognizer(leftSwipeGR)
        
        let rightSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(self.collectionViewSwiped))
        rightSwipeGR.direction = .right
        self.collectionView.addGestureRecognizer(rightSwipeGR)
    }
    
    @objc private func collectionViewSwiped(sender: UISwipeGestureRecognizer) {
        let oldDayType = self.dayType
        if sender.direction == .right {
            self.dayType = .morning
            self.segmentedControl.selectedSegmentIndex = 0
        } else {
            self.dayType = .evening
            self.segmentedControl.selectedSegmentIndex = 1
        }
        if oldDayType != self.dayType {
            self.getDataFromCoreDataAndReloadViews()
            self.feedbackGenerator.impactOccurred(intensity: 0.5)
        }
    }
    
    func updateDayTypeBasedOnTime() {
        let todayString = DateFormatter.basicFormatter.string(from: Date.now)
        let currentDayString = DateFormatter.basicFormatter.string(from: self.calendarView.selectedDate ?? Date())
        if todayString == currentDayString {
            var calendar = Calendar.current
            calendar.locale = .current
            let hour = calendar.component(.hour, from: Date.now)
            let oldDayType = self.dayType
            if hour < 16, hour > 8 {
                self.dayType = .morning
                self.segmentedControl.selectedSegmentIndex = 0
            } else {
                self.dayType = .evening
                self.segmentedControl.selectedSegmentIndex = 1
            }
            // We reload data from CoreData only if dayType is changed
            if oldDayType != self.dayType { self.getDataFromCoreDataAndReloadViews() }
        }
    }
}
