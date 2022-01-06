import Foundation

public extension Date {
    /// SwiftyHolidays: Returns an instance of `LocalDate` with the same date, but without information about time.
    ///
    /// - Parameters:
    ///   - timeZone: Time zone to interpret the date.
    func asLocalDate(in timeZone: TimeZone = TimeZone(abbreviation: "CET")!) -> LocalDate {
        return LocalDate(date: self, timeZone: timeZone)
    }

    /// SwiftyHolidays: Returns true if there's a holiday at that date in a given country and time zone.
    ///
    /// - Parameters:
    ///   - country: Country to check for holidays in. Refer to `Country.availableCountries` for a list of available countries.
    ///   - timeZone: Time zone to interpret the date. If left unspecified, the default time zone for the given country will be used.
    func isHoliday(in country: Country, timeZone: TimeZone? = nil) -> Bool {
        return getHoliday(in: country, timeZone: timeZone) != nil
    }

    /// SwiftyHolidays: Returns a `Holiday` instance if the date is a holiday in a given country and time zone.
    ///
    /// - Parameters:
    ///   - country: Country to check for holidays in. Refer to `Country.availableCountries` for a list of available countries.
    ///   - timeZone: Time zone to interpret the date. If left unspecified, the default time zone for the given country will be used.
    func getHoliday(in country: Country, timeZone: TimeZone? = nil) -> Holiday? {
        return LocalDate(date: self, timeZone: timeZone ?? country.model.defaultTimeZone).getHoliday(in: country)
    }
}
