//
//  Calendar - Ext.swift
//  Bdc
//
//  Created by leobartowski on 24/10/24.
//
import Foundation

extension Calendar {
    
    static let itBasic: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = .current
        calendar.minimumDaysInFirstWeek = 4
        return calendar
    }()
}
