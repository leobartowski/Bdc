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

open class YearPickerView: UIControl {

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
            yearDateFormatter.calendar = calendar
            yearDateFormatter.timeZone = calendar.timeZone
        }
    }

    /// default is nil
    open var locale: Locale? {
        didSet {
            calendar.locale = locale
            yearDateFormatter.locale = locale
        }
    }

    lazy private var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        // swiftlint:disable legacy_constructor
        pickerView.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return pickerView
    }()

    lazy private var yearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("y")
        return formatter
    }()
    
    fileprivate enum Component: Int {
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
        guard let yearRange = calendar.maximumRange(of: .year) else { return }
        let year = self.calendar.component(.year, from: date) - yearRange.lowerBound
        self.pickerView.selectRow(year, inComponent: .year, animated: animated)
        self.pickerView.reloadAllComponents()
    }

    internal func isValidDate(_ date: Date) -> Bool {
        if let minimumDate = minimumDate, let maximumDate = maximumDate,
            calendar.compare(minimumDate, to: maximumDate, toGranularity: .year) == .orderedDescending { return true }
        if let minimumDate = minimumDate, calendar.compare(minimumDate, to: date, toGranularity: .year) == .orderedDescending { return false }
        if let maximumDate = maximumDate, calendar.compare(date, to: maximumDate, toGranularity: .year) == .orderedDescending { return false }
        return true
    }
    
}

extension YearPickerView: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dateComponents = self.calendar.dateComponents([.hour, .minute, .second], from: date)
        dateComponents.year = value(for: pickerView.selectedRow(inComponent: .year), representing: .year)
        guard let date = calendar.date(from: dateComponents) else { return }
        self.date = date
    }
    
}

extension YearPickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        guard let component = Component(rawValue: component) else { return 0 }
        return self.calendar.maximumRange(of: .year)?.count ?? 0
    }

    private func value(for row: Int, representing component: Calendar.Component) -> Int? {
        guard let range = calendar.maximumRange(of: component) else { return nil }
        return range.lowerBound + row
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if #available(iOS 14.0, *) { pickerView.subviews[1].backgroundColor = .clear }
        
        let label: UILabel = view as? UILabel ?? {
            let label = UILabel()
            label.font = .systemFont(ofSize: 25, weight: .regular)
            label.adjustsFontForContentSizeCategory = true
            label.textAlignment = .center
            return label
        }()

//        guard let component = Component(rawValue: component) else { return label }
        var dateComponents = self.calendar.dateComponents([.hour, .minute, .second], from: date)
        dateComponents.month = 1
        dateComponents.year = self.value(for: row, representing: .year)
        
        guard let date = calendar.date(from: dateComponents) else { return label }
        label.text = self.yearDateFormatter.string(from: date)
        
        if self.isValidDate(date) {
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
    func selectedRow(inComponent component: YearPickerView.Component) -> Int {
        self.selectedRow(inComponent: component.rawValue)
    }

    func selectRow(_ row: Int, inComponent component: YearPickerView.Component, animated: Bool) {
        self.selectRow(row, inComponent: component.rawValue, animated: animated)
    }
}
