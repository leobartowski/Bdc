//
//  RankingViewController.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 23/10/21.
//

import UIKit
import SpreadsheetView
import FSCalendar

class RankingViewController: UIViewController {

    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.scope = .week // Needed to show the weekly at start!
        self.viewSetUp()
    }
    
    func viewSetUp() {
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.delegate = self
    }
    

    
}
