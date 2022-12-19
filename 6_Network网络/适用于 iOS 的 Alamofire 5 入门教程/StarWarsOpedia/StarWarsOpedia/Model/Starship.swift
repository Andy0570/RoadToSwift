import Foundation

struct Starship: Decodable {
    var name: String
    var model: String
    var manufacturer: String
    var cost: String
    var length: String
    var maximumSpeed: String
    var crewTotal: String
    var passengerTotal: String
    var cargoCapacity: String
    var consumables: String
    var hyperdriveRating: String
    var starshipClass: String
    var films: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case model
        case manufacturer
        case cost = "cost_in_credits"
        case length
        case maximumSpeed = "max_atmosphering_speed"
        case crewTotal = "crew"
        case passengerTotal = "passengers"
        case cargoCapacity = "cargo_capacity"
        case consumables
        case hyperdriveRating = "hyperdrive_rating"
        case starshipClass = "starship_class"
        case films
    }
}

extension Starship: Displayable {
    var titleLabelText: String {
        return name
    }
    
    var subtitleLabelText: String {
        return model
    }
    
    var item1: (label: String, value: String) {
        return ("MANUFACTURER", manufacturer)
    }
    
    var item2: (label: String, value: String) {
        return ("CLASS", starshipClass)
    }
    
    var item3: (label: String, value: String) {
        return ("HYPERDRIVE RATING", hyperdriveRating)
    }
    
    var listTitle: String {
        return "FILMS"
    }
    
    var listItems: [String] {
        return films
    }
}
