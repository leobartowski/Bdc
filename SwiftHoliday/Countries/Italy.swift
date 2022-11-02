//
//  Italy.swift
//  SwiftHoliday
//
//  Created by leobartowski on 05/01/22.
//

import Foundation

// https://en.wikipedia.org/wiki/Public_holidays_in_Italy
final class Italy: CountryBase {
    
    override class var iso2Code: String { "IT" }
    override class var iso3Code: String { "ITA" }

    override var defaultTimeZone: TimeZone { TimeZone(abbreviation: "CET")! }

    override func allHolidays(in year: Int) -> [Holiday] {
        
        guard year != 0 else { return [] }
        
        let easter = LocalDate.easter(in: year)
        return [
            Holiday(name: "Capodanno", date: (year, .january, 1)),
            Holiday(name: "Epifania", date: (year, .january, 6)),
//            Holiday(name: "Carnevale", date:  easter.addingDays(-47)),
            Holiday(name: "Pasqua", date:  easter),
            Holiday(name: "Pasquetta", date: easter.addingDays(1)),
            Holiday(name: "Festa della Liberazione", date: (year, .april, 25)),
            Holiday(name: "Primo maggio", date: (year, .may, 1)),
            Holiday(name: "Festa Della Repubblica", date: (year, .june, 2)),
            Holiday(name: "Ferragosto", date: (year, .august, 15)),
            Holiday(name: "San Sossio", date: (year, .september, 23)),
//            Holiday(name: "Ognissanti", date: (year, .november, 1)), // IT BREAKS THE APP
            Holiday(name: "Immacolata", date: (year, .december, 8)),
            Holiday(name: "Vigilia di Natale", date: (year, .december, 24)),
            Holiday(name: "Natale", date: (year, .december, 25)),
            Holiday(name: "Santo Stefano", date: (year, .december, 26)),
            Holiday(name: "Vigilia di Capodanno", date: (year, .december, 31))
        ]
    }
}
