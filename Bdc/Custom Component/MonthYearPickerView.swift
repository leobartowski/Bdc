//
//  MonthYearPickerView.swift
//  MonthYearPicker
//
//  Copyright (c) 2016 Alexander Edge <alex@alexedge.co.uk>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
import UIKit

open class MonthYearPickerView: UIControl {
    
    /// specify min date. default is nil. When `minimumDate` > `maximumDate`, the values are ignored.
    /// If `date` is earlier than `minimumDate` when it is set, `date` is changed to `minimumDate`.
    open var minimumDate: Date? {
        didSet {
            guard let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending else { return }
            date = minimumDate
        }
    }
    
    /// specify max date. default is nil. When `minimumDate` > `maximumDate`, the values are ignored.
    /// If `date` is later than `maximumDate` when it is set, `date` is changed to `maximumDate`.
    open var maximumDate: Date? {
        didSet {
            guard let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending else { return }
            date = maximumDate
        }
    }
    
    /// default is current date when picker created
    open var date: Date = Date() {
        didSet {
            if let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending {
                date = calendar.date(from: calendar.dateComponents([.year, .month], from: minimumDate)) ?? minimumDate
            } else if let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending {
                date = calendar.date(from: calendar.dateComponents([.year, .month], from: maximumDate)) ?? maximumDate
            }
            setDate(date, animated: true)
            sendActions(for: .valueChanged)
        }
    }
    
    /// default is current calendar when picker created
    open var calendar: Calendar = Calendar.autoupdatingCurrent {
        didSet {
            monthDateFormatter.calendar = calendar
            monthDateFormatter.timeZone = calendar.timeZone
            yearDateFormatter.calendar = calendar
            yearDateFormatter.timeZone = calendar.timeZone
        }
    }
    
    /// default is nil
    open var locale: Locale? {
        didSet {
            calendar.locale = locale
            monthDateFormatter.locale = locale
            yearDateFormatter.locale = locale
        }
    }
    
    lazy private var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: self.bounds)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return pickerView
    }()
    
    lazy private var monthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter
    }()
    
    lazy private var yearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("y")
        return formatter
    }()
    
    fileprivate enum Component: Int {
        case month
        case year
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    private func initialSetup() {
        
        addSubview(self.pickerView)
        self.calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        self.setDate(self.date, animated: false)
    }
    
    /// if animated is YES, animate the wheels of time to display the new date
    open func setDate(_ date: Date, animated: Bool) {
        guard let yearRange = calendar.maximumRange(of: .year), let monthRange = calendar.maximumRange(of: .month) else {
            return
        }
        let month = self.calendar.component(.month, from: date) - monthRange.lowerBound
        self.pickerView.selectRow(month, inComponent: .month, animated: animated)
        let year = self.calendar.component(.year, from: date) - yearRange.lowerBound
        self.pickerView.selectRow(year, inComponent: .year, animated: animated)
        self.pickerView.reloadAllComponents()
    }
    
    internal func isValidDate(_ date: Date, isMonth: Bool = true) -> Bool {
        if isMonth {
            if let minimumDate = minimumDate,
               let maximumDate = maximumDate, calendar.compare(minimumDate, to: maximumDate, toGranularity: .month) == .orderedDescending { return true }
            if let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .month) == .orderedDescending { return false }
            if let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .month) == .orderedDescending { return false }
            return true
        } else {
            if let minimumDate = minimumDate, let maximumDate = maximumDate,
               calendar.compare(minimumDate, to: maximumDate, toGranularity: .year) == .orderedDescending { return true }
            if let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .year) == .orderedDescending { return false }
            if let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .year) == .orderedDescending { return false }
            return true
        }
    }
}

extension MonthYearPickerView: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dateComponents = self.calendar.dateComponents([.hour, .minute, .second], from: date)
        dateComponents.year = value(for: pickerView.selectedRow(inComponent: .year), representing: .year)
        dateComponents.month = value(for: pickerView.selectedRow(inComponent: .month), representing: .month)
        guard let date = calendar.date(from: dateComponents) else { return }
        self.date = date
    }
    
}

extension MonthYearPickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let component = Component(rawValue: component) else { return 0 }
        switch component {
        case .month:
            return self.calendar.maximumRange(of: .month)?.count ?? 0
        case .year:
            return self.calendar.maximumRange(of: .year)?.count ?? 0
        }
    }
    
    private func value(for row: Int, representing component: Calendar.Component) -> Int? {
        guard let range = calendar.maximumRange(of: component) else { return nil }
        return range.lowerBound + row
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if #available(iOS 14.0, *) { pickerView.subviews[1].backgroundColor = .clear }
        
        let label: UILabel = view as? UILabel ?? {
            let label = UILabel()
            label.adjustsFontForContentSizeCategory = true
            label.textAlignment = .center
            return label
        }()
        
        guard let component = Component(rawValue: component) else { return label }
        var dateComponents = self.calendar.dateComponents([.hour, .minute, .second], from: date)
        
        switch component {
        case .month:
            dateComponents.month = self.value(for: row, representing: .month)
            dateComponents.year = self.value(for: pickerView.selectedRow(inComponent: .year), representing: .year)
        case .year:
            dateComponents.month = self.value(for: pickerView.selectedRow(inComponent: .month), representing: .month)
            dateComponents.year = self.value(for: row, representing: .year)
        }
        
        guard let date = calendar.date(from: dateComponents) else { return label }
        
        switch component {
        case .month:
            label.text = self.monthDateFormatter.string(from: date)
        case .year:
            label.text = self.yearDateFormatter.string(from: date)
        }
        if self.isValidDate(date, isMonth: component == .month ? true : false) {
            label.font = .systemFont(ofSize: 25, weight: .medium)
            label.textColor = .black
        } else {
            label.font = .systemFont(ofSize: 25, weight: .light)
            label.textColor = .lightGray
        }
        return label
    }
}

private extension UIPickerView {
    func selectedRow(inComponent component: MonthYearPickerView.Component) -> Int {
        self.selectedRow(inComponent: component.rawValue)
    }
    
    func selectRow(_ row: Int, inComponent component: MonthYearPickerView.Component, animated: Bool) {
        self.selectRow(row, inComponent: component.rawValue, animated: animated)
    }
}
