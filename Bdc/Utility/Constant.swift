//
//  Constant.swift
//  Bdc
//
//  Created by leobartowski on 23/12/21.
//

import Foundation

enum Constant {
    
    static let startingDateBdC = DateFormatter.basicFormatter.date(from: "25/10/2021") ?? Date.now
    static let endingDateBdC = DateFormatter.basicFormatter.date(from: "25/10/2025") ?? Date.now
    static let maxAttWeeklyIndividual: Double = 10
    static let maxAttMonthlyIndividual: Double = 46
    static let maxAttYearlyIndividual: Double = 510
    static let maxAttWeeklySlotIndividual: Double = 5
    static let maxAttMonthlySlotIndividual: Double = 23
    static let maxAttYearlySlotIndividual: Double = 255
}
