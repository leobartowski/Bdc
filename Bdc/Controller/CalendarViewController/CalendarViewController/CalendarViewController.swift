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
    @IBOutlet var segmentedControl: MySegmentedControl!
    @IBOutlet var bottomCalendarHandleView: UIView!
    @IBOutlet var goToTodayButton: UIButton!
    @IBOutlet var segmentedControlContainerView: UIView!
    @IBOutlet var calendarViewHeightConstraint: NSLayoutConstraint!
    var attendanceCVViewController: AttendanceCollectionViewController!
    
    var dayType = DayType.evening
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAttendanceVC()
        self.setUpCalendarAppearance()
        self.setupSegmentedControl()
        self.addCalendarGestureRecognizer()
        self.designBottomCalendarHandleView()
        self.updateGoToTodayButton()
        self.addObservers()
    }
    
    private func getAttendanceVC() {
        if let navigationControllerCV = self.children.first as? UINavigationController,
           let vc = navigationControllerCV.viewControllers.first as? AttendanceCollectionViewController {
            self.attendanceCVViewController = vc
        }
    }

    //   Get called when the app is become active
    @objc func willBecomeActive() {
        self.updateDayTypeBasedOnTime()
    }
    
    @objc func systemTimeChanged() {
        self.updateCalendarIfNeeded()
    }
    
    // MARK: Utils and Design
    
    /// Add shadow and corner radius to bottom Calendar Handle View
    func designBottomCalendarHandleView() {
        self.bottomCalendarHandleView.layer.shadowColor = UIColor.gray.cgColor
        self.bottomCalendarHandleView.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        self.bottomCalendarHandleView.layer.shadowOpacity = 0.3
        self.bottomCalendarHandleView.layer.shadowRadius = 2
        self.bottomCalendarHandleView.layer.masksToBounds = false
        self.bottomCalendarHandleView.layer.cornerRadius = 13
        self.bottomCalendarHandleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.systemTimeChanged), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    func updateGoToTodayButton() {
        self.goToTodayButton.alpha = Date().isThisDaySelectable() ? 1 : 0.3
    }
    
    func automaticScrollToToday() {
        DispatchQueue.main.async {
            self.calendarView.setCurrentPage(Date.now, animated: true)
            self.calendarView.select(Date.now)
            self.attendanceCVViewController.getDataFromCoreDataAndReloadViews()
        }
    }
    
    
    func setupSegmentedControl() {
        self.segmentedControl.backgroundColor = .white
        self.segmentedControl.layer.shadowColor = Theme.FSCalendarStandardLightSelectionColor.cgColor
        self.segmentedControl.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.segmentedControl.layer.shadowOpacity = 0.5
        self.segmentedControl.layer.shadowRadius = 3
        self.segmentedControl.layer.masksToBounds = false
        self.segmentedControl.borderColor = Theme.FSCalendarStandardSelectionColor
        self.segmentedControl.selectedSegmentTintColor = Theme.FSCalendarStandardSelectionColor
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.segmentedControl.setTitleTextAttributes(titleTextAttributes1, for: .normal)
    }
    
    // MARK: Morning and Evening Selector
    
    func updateDayTypeBasedOnTime() {
        let todayString = DateFormatter.basicFormatter.string(from: Date.now)
        let currentDayString = DateFormatter.basicFormatter.string(from: self.calendarView.selectedDate ?? Date())
        if todayString == currentDayString {
            var calendar = Calendar.current
            calendar.locale = .current
            let hour = calendar.component(.hour, from: Date.now)
            let oldDayType = self.dayType
            if hour < 16, hour > 8 { // morning
                self.dayType = .morning
                self.segmentedControl.selectedSegmentIndex = 0
            } else { // evening
                self.dayType = .evening
                self.segmentedControl.selectedSegmentIndex = 1
            }
            // We reload data from CoreData only if dayType is changed
            if oldDayType != self.dayType { self.attendanceCVViewController.getDataFromCoreDataAndReloadViews() }
        }
    }
    
    func reloadCalendarDateIfNeeded() {
        if self.calendarView.maximumDate < Date.now {
            self.updateGoToTodayButton()
            self.calendarView.reloadData()
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
    
    // MARK: IBActions
    
    @IBAction func segmentedControlValueChanged(_: Any) {
        //        self.saveCurrentDataInCoreData()
        switch self.segmentedControl.selectedSegmentIndex {
        case 0: self.dayType = .morning
        case 1: self.dayType = .evening
        default: break
        }
        self.attendanceCVViewController.getDataFromCoreDataAndReloadViews()
    }
    
    @IBAction func goToTodayTouchUpInside(_: Any) {
        !Date().isThisDaySelectable()
        ? self.presentAlert(alertText: "Hey!", alertMessage: "Mi dispiace, ma dovresti sapere che oggi non si prendono presenze!")
        : self.automaticScrollToToday()
    }
}
