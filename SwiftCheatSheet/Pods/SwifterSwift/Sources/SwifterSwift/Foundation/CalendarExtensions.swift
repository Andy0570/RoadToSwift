// CalendarExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(Foundation)
import Foundation

// MARK: - Methods

public extension Calendar {
    /// SwifterSwift: Return the number of days in the month for a specified 'Date'.
    ///
    ///		let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///		Calendar.current.numberOfDaysInMonth(for: date) -> 31
    ///
    /// - Parameter date: the date form which the number of days in month is calculated.
    /// - Returns: The number of days in the month of 'Date'.
    func numberOfDaysInMonth(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)!.count
    }
}

public extension Calendar.Component {
    /// SwifterSwift: Format components.
    ///
    ///     Calendar.Component.month.formatted(numberOfUnits: 2, unitsStyle: .full) // 2 months
    ///     Calendar.Component.day.formatted(numberOfUnits: 15, unitsStyle: .short) // 15 days
    ///     Calendar.Component.year.formatted(numberOfUnits: 1, unitsStyle: .abbreviated) // 1y
    ///
    /// - Parameters:
    ///   - numberOfUnits: Count of units of component.
    ///   - unitsStyle: Style of formatting of units.
    /// - Returns: formatted string
    func formatted(numberOfUnits: Int, unitsStyle: DateComponentsFormatter.UnitsStyle = .full) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = unitsStyle
        formatter.zeroFormattingBehavior = .dropAll
        var dateComponents = DateComponents()
        dateComponents.setValue(numberOfUnits, for: self)
        return formatter.string(from: dateComponents)
    }
}

#endif
