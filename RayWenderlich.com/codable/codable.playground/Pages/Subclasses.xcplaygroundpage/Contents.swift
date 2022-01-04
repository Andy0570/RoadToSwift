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

class BasicEmployee: Codable {
    var name: String
    var id: Int

    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

class GiftEmployee: BasicEmployee {
    var birthday: Date
    var toy: Toy

    enum CodingKeys: CodingKey {
        case employee, birthday, toy
    }

    // MARK: 自定义编码
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(toy, forKey: .toy)

        let baseEncoder = container.superEncoder(forKey: .employee)
        try super.encode(to: baseEncoder)
    }

    // MARK: 自定义解码
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        birthday = try container.decode(Date.self, forKey: .birthday)
        toy = try container.decode(Toy.self, forKey: .toy)
        
        let baseDecoder = try container.superDecoder(forKey: .employee)
        try super.init(from: baseDecoder)
    }

    init(name: String, id: Int, birthday: Date, toy: Toy) {
        self.birthday = birthday
        self.toy = toy
        super.init(name: name, id: id)
    }
}

let toy = Toy(name: "Teddy Bear")
let giftEmployee = GiftEmployee(name: "John Appleseed", id: 7, birthday: Date(), toy: toy)

let encoder = JSONEncoder()
let decoder = JSONDecoder()

// MARK: Model -> JSON
let giftData = try encoder.encode(giftEmployee)
let giftString = String(data: giftData, encoding: .utf8)

// MARK: JSON -> Model
let sameGiftEmployee = try decoder.decode(GiftEmployee.self, from: giftData)
