import Foundation

public extension UserDefaults {
    func date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }

    func set<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try? JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }

    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else { return nil }
        return try JSONDecoder().decode(objectType, from: result)
    }
}
