import Foundation

class HolidaysBuilder {
    let year: Int

    init(year: Int) {
        self.year = year
    }

    var holidays = [Holiday]()

    func addHoliday(_ name: String, date: LocalDate) {
        self.holidays.append(Holiday(name: name, date: date))
    }

    func addHoliday(_ name: String, date: (Month, Int)) {
        self.holidays.append(Holiday(name: name, date: (self.year, date.0, date.1)))
    }

    func getHolidays() -> [Holiday] {
        return self.holidays
    }
}
