/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct Toy: Codable {
    var name: String
}

// AnyEmployee 是一个有关联值的枚举类型
enum AnyEmployee: Encodable {
    case defaultEmployee(String, Int)
    case customEmployee(String, Int, Date, Toy)
    case noEmployee

    enum CodingKeys: CodingKey {
        case name, id, birthday, toy
    }

    // MARK: 自定义编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .defaultEmployee(let name, let id):
            try container.encode(name, forKey: .name)
            try container.encode(id, forKey: .id)
        case .customEmployee(let name, let id, let birthday, let toy):
            try container.encode(name, forKey: .name)
            try container.encode(id, forKey: .id)
            try container.encode(birthday, forKey: .birthday)
            try container.encode(toy, forKey: .toy)
        case .noEmployee:
            let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid employee!")
            throw EncodingError.invalidValue(self, context)
        }
    }
}

extension AnyEmployee: Decodable {
    // MARK: 自定义解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let containerKeys = Set(container.allKeys)
        let defaultKeys = Set<CodingKeys>([.name, .id])
        let customKeys = Set<CodingKeys>([.name, .id, .birthday, .toy])

        switch containerKeys {
        case defaultKeys:
            let name = try container.decode(String.self, forKey: .name)
            let id = try container.decode(Int.self, forKey: .id)
            self = .defaultEmployee(name, id)
        case customKeys:
            let name = try container.decode(String.self, forKey: .name)
            let id = try container.decode(Int.self, forKey: .id)
            let birthday = try container.decode(Date.self, forKey: .birthday)
            let toy = try container.decode(Toy.self, forKey: .toy)
            self = .customEmployee(name, id, birthday, toy)
        default:
            self = .noEmployee
        }
    }
}

let toy = Toy(name: "Teddy Bear")
let employees = [AnyEmployee.defaultEmployee("John Appleseed", 7),
                 AnyEmployee.customEmployee("John Appleseed", 7, Date(), toy)]

let encoder = JSONEncoder()
let decoder = JSONDecoder()

// MARK: Model -> JSON
let employeesData = try encoder.encode(employees)
let employeesString = String(data: employeesData, encoding: .utf8)!

// MARK: JSON -> Model
let sameEmployees = try decoder.decode([AnyEmployee].self, from: employeesData)
