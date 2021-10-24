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
        self.viewSetUp()
        self.addExampleData()
    }
    
    // TODO: CLEAN THIS MESS!
    //-----------------------------------------------
    enum Sorting {
        case ascending
        case descending

        var symbol: String {
            switch self {
            case .ascending:
                return "\u{25B2}"
            case .descending:
                return "\u{25BC}"
            }
        }
    }
    var sortedColumn = (column: 0, sorting: Sorting.ascending)
    var header = [String]()
    var data = [[String]]()
    
    //--------------------------------------------
    
    func viewSetUp() {
        // Spreadsheet
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.delegate = self
        self.spreadsheetView.bounces = false
        self.spreadsheetView.showsVerticalScrollIndicator = false
        self.spreadsheetView.showsHorizontalScrollIndicator = false
        self.spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        self.spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        // Calendar
        self.calendarView.scope = .week // Needed to show the weekly at start!
        self.calendarView.allowsMultipleSelection = true
        self.selectedAllDateOfTheWeek(self.calendarView.selectedDate ?? Date.now)
    }
    
    func addExampleData() {
        let data = try! String(contentsOf: Bundle.main.url(forResource: "data", withExtension: "tsv")!, encoding: .utf8)
            .components(separatedBy: "\r\n")
            .map { $0.components(separatedBy: "\t") }
        header = ["Nome", "Presenze", "Ammonizioni"]
        self.data = Array(data.dropFirst())
    }
    
    func createData() {
//        let persons = Utility.persons
//        for ciro in self.data[0]
        
    }

}
