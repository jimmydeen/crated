import Foundation

enum DatePrecision: String, Hashable {
    case year, month, day
}

class DateUtilities {
    private static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func formatStringToDate(date: String, precision: DatePrecision) -> Date {
        switch precision {
            case .day: return dayFormatter.date(from: date) ?? .now
            case .month: return monthFormatter.date(from: date) ?? .now
            case .year: return yearFormatter.date(from: date) ?? .now
        }
    }

    static func formatDateToString(date: Date, precision: DatePrecision) -> String {
        switch precision {
            case .day: return dayFormatter.string(from: date)
            case .month: return monthFormatter.string(from: date)
            case .year: return yearFormatter.string(from: date)
        }
    }
}
