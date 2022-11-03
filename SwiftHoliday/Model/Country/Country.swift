import Foundation

/// Represents a country and can be used to retrieve its holidays.
public enum Country: String, CaseIterable, CountryProtocol {
    
    case italy
    
    // MARK: Public
    
    /// SwiftyHolidays: Returns a `Country` if a country with the given ISO code exists and is supported by SwiftyHolidays.
    ///
    /// - Parameter isoCode: A 2 or 3 digit ISO 3166 country code.
    public init?(isoCode: String) {
        guard 2...3 ~= isoCode.count else { return nil }
        if let type = Self.countryTypes.first(where: { $0.iso2Code == isoCode.uppercased() || $0.iso3Code ==
            isoCode.uppercased() }) {
            let typeString = String(describing: type)
            if let country = Self.init(rawValue: typeString.prefix(1).lowercased() + typeString.dropFirst()) {
                self = country
                return
            }
        }
        return nil
    }
    
    /// SwiftyHolidays: The 2 digit ISO 3166 country code.
    public var iso2Code: String {
        return type(of: self.model).iso2Code
    }
    
    /// SwiftyHolidays: The 3 digit ISO 3166 country code.
    public var iso3Code: String {
        return type(of: self.model).iso3Code
    }
    
    /// SwiftyHolidays: The country's default time zone.
    public var defaultTimeZone: TimeZone {
        return self.model.defaultTimeZone
    }
    
    /// SwiftyHolidays: Returns a localized display string for the country.
    ///
    /// - Parameter locale: The locale to use for localizing the country's name.
    public func displayString(locale: Locale = .current) -> String {
        return locale.localizedString(forRegionCode: self.iso2Code) ?? ""
    }
    
    /// SwiftyHolidays: Returns all holidays of the country in a given year.
    public func allHolidays(in year: Int) -> [Holiday] {
        return self.model.allHolidays(in: year)
    }
    
    /// Holidays:  Returns all holidays of the country in a given year as [Date]
    public func allHolidaysAsDates(in year: Int) -> [Date] {
        var dates: [Date] = []
        for holiday in self.model.allHolidays(in: year) {
            let date = holiday.date.asDate()
            dates.append(date)
        }
        return dates
    }
    
    /// SwifterSwift: Returns a list of all available countries.
    public static var availableCountries: [String] {
        return allCases.map { $0.rawValue }
    }
    
    // MARK: Internal
    
    static var countryTypes: [CountryBase.Type] {
        return [Italy.self]
    }
    
    var model: CountryBase {
        switch self {
        case .italy:
            return Italy()
        }
    }
}
