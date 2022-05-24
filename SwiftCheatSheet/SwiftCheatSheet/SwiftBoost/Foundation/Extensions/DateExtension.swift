import Foundation

public extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    // MARK: - Edit

    func add(_ component: Calendar.Component, value: Int = 1) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }

    mutating func add(_ component: Calendar.Component, value: Int = 1) {
        if let date = Calendar.current.date(byAdding: component, value: value, to: self) {
            self = date
        }
    }

    func previous(_ component: Calendar.Component) -> Date {
        add(component, value: -1)
    }

    func next(_ component: Calendar.Component) -> Date {
        add(component)
    }

    /**
     SwiftBoost: Returns the start of component.
     
     - important: If it was not possible to get the end of the component, then self is returned.
     - parameter component: The component you want to get the start of (year, month, day, etc.).
     - returns: The start of component.
     */
    func start(of component: Calendar.Component) -> Date {
        if component == .day {
            return Calendar.current.startOfDay(for: self)
        }
        var components: Set<Calendar.Component> {
            switch component {
            case .second: return [.year, .month, .day, .hour, .minute, .second]
            case .minute: return [.year, .month, .day, .hour, .minute]
            case .hour: return [.year, .month, .day, .hour]
            case .day: return [.year, .month, .day]
            case .weekOfYear, .weekOfMonth: return [.yearForWeekOfYear, .weekOfYear]
            case .month: return [.year, .month]
            case .year: return [.year]
            default: return []
            }
        }
        guard components.isEmpty == false else { return self }
        return Calendar.current.date(from: Calendar.current.dateComponents(components, from: self)) ?? self
    }

    /**
     SwiftBoost: Returns the end of component.
     
     - important: If it was not possible to get the end of the component, then self is returned.
     - parameter component: The component you want to get the end of (year, month, day, etc.).
     - returns: The end of component.
     */
    func end(of component: Calendar.Component) -> Date {
        let date = self.start(of: component)
        var components: DateComponents? {
            switch component {
            case .second:
                var components = DateComponents()
                components.second = 1
                components.nanosecond = -1
                return components
            case .minute:
                var components = DateComponents()
                components.minute = 1
                components.second = -1
                return components
            case .hour:
                var components = DateComponents()
                components.hour = 1
                components.second = -1
                return components
            case .day:
                var components = DateComponents()
                components.day = 1
                components.second = -1
                return components
            case .weekOfYear, .weekOfMonth:
                var components = DateComponents()
                components.weekOfYear = 1
                components.second = -1
                return components
            case .month:
                var components = DateComponents()
                components.month = 1
                components.second = -1
                return components
            case .year:
                var components = DateComponents()
                components.year = 1
                components.second = -1
                return components
            default:
                return nil
            }
        }
        guard let addedComponent = components else { return self }
        return Calendar.current.date(byAdding: addedComponent, to: date) ?? self
    }

    // MARK: - Formatting

    func formatted(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style = .none) -> String {
        DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }

    /**
     SwiftBoost: Localise date by format.
     
     You can manually manage date formatted or set localised.
     
     Take a look at this example:
     ```
     print(Date().formatted(localized: true)) // 05/16/2022, 14:17
     print(Date().formatted(localized: false)) // 16.05.2022 14:17
     ```
     
     - parameter numberOfUnits: Count of units of component.
     - parameter unitsStyle: Style of formatting of units.
     */
    func formatted(as format: String = "dd.MM.yyyy HH:mm", localized: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        if localized {
            dateFormatter.setLocalizedDateFormatFromTemplate(format)
        } else {
            dateFormatter.dateFormat = format
        }
        return dateFormatter.string(from: self)
    }

    func formattedInterval(to date: Date, dateStyle: DateIntervalFormatter.Style, timeStyle: DateIntervalFormatter.Style = .none) -> String {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self, to: date)
    }
}
