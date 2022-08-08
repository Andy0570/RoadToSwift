import Foundation

struct Pet: Hashable {
    enum Category: CaseIterable, CustomStringConvertible {
        case birds, cats, chameleons, cows, dogs, monkeys, penguins, pigs, rats, snakes, squirrels
    }
    let imageName: String
    let name: String
    let birthYear: Int
    var age: Int {
        let thisYear = Calendar.current.component(.year, from: Date())
        return thisYear - birthYear
    }
    let category: Category
    private let id = UUID()
}

extension Pet.Category {
    var description: String {
        switch self {
        case .birds: return "Birds"
        case .cats: return "Cats"
        case .chameleons: return "Chameleons"
        case .cows: return "Cows"
        case .dogs: return "Dogs"
        case .monkeys: return "Monkeys"
        case .penguins: return "Penguins"
        case .pigs: return "Pigs"
        case .rats: return "Rats"
        case .snakes: return "Snakes"
        case .squirrels: return "Squirrels"
        }
    }

    var pets: [Pet] {
        switch self {
        case .birds:
            return [
                Pet(imageName: "bird1", name: "Happy", birthYear: 2017, category: self),
                Pet(imageName: "bird2", name: "Swifty", birthYear: 2018, category: self),
                Pet(imageName: "bird3", name: "Speedy", birthYear: 2018, category: self)
            ]
        case .cats:
            return [
                Pet(imageName: "cat1", name: "Max", birthYear: 2015, category: self),
                Pet(imageName: "cat2", name: "Jake", birthYear: 2018, category: self),
                Pet(imageName: "cat3", name: "Daisy", birthYear: 2012, category: self),
                Pet(imageName: "cat4", name: "Sunny", birthYear: 2008, category: self),
                Pet(imageName: "cat5", name: "Oscar", birthYear: 2017, category: self)
            ]
        case .chameleons:
            return [
                Pet(imageName: "chameleon1", name: "Zoe", birthYear: 2015, category: self)
            ]
        case .cows:
            return [
                Pet(imageName: "cow1", name: "Betty", birthYear: 2016, category: self),
                Pet(imageName: "cow2", name: "Rosie", birthYear: 2013, category: self)
            ]
        case .dogs:
            return [
                Pet(imageName: "dog1", name: "Buddy", birthYear: 2018, category: self),
                Pet(imageName: "dog2", name: "Molly", birthYear: 2014, category: self),
                Pet(imageName: "dog3", name: "Bella", birthYear: 2009, category: self),
                Pet(imageName: "dog4", name: "Dixie", birthYear: 2018, category: self),
                Pet(imageName: "dog5", name: "Freddy", birthYear: 2012, category: self),
                Pet(imageName: "dog6", name: "Lucky", birthYear: 2016, category: self),
                Pet(imageName: "dog7", name: "Snoopy", birthYear: 2015, category: self),
                Pet(imageName: "dog8", name: "Joker", birthYear: 2018, category: self),
                Pet(imageName: "dog9", name: "Diego", birthYear: 2018, category: self),
                Pet(imageName: "dog10", name: "Bruno", birthYear: 2016, category: self)
            ]
        case .monkeys:
            return [
                Pet(imageName: "monkey1", name: "Turbo", birthYear: 2015, category: self)
            ]
        case .penguins:
            return [
                Pet(imageName: "penguin1", name: "Helen", birthYear: 2017, category: self),
                Pet(imageName: "penguin2", name: "Fred", birthYear: 2014, category: self)
            ]
        case .pigs:
            return [
                Pet(imageName: "pig1", name: "Piggy", birthYear: 2015, category: self)
            ]
        case .rats:
            return [
                Pet(imageName: "rat1", name: "Cutie", birthYear: 2018, category: self)
            ]
        case .snakes:
            return [
                Pet(imageName: "snake1", name: "Worm", birthYear: 2013, category: self),
                Pet(imageName: "snake2", name: "Noodles", birthYear: 2018, category: self),
                Pet(imageName: "snake3", name: "Slider", birthYear: 2017, category: self)
            ]
        case .squirrels:
            return [
                Pet(imageName: "squirrel1", name: "Chippy", birthYear: 2017, category: self)
            ]
        }
    }
}
