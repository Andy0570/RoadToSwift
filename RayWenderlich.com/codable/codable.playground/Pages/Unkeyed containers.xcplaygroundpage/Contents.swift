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

struct Label: Encodable {
    var toy: Toy

    // MARK: 自定义编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(toy.name.lowercased())
        try container.encode(toy.name.uppercased())
        try container.encode(toy.name)
    }
}

extension Label: Decodable {
    // MARK: 自定义解码
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var name = ""
        while !container.isAtEnd {
            name = try container.decode(String.self)
        }
        toy = Toy(name: name)
    }
}

let toy = Toy(name: "Teddy Bear")
let label = Label(toy: toy)

let encoder = JSONEncoder()
let decoder = JSONDecoder()

// MARK: Model -> JSON
let labelData = try encoder.encode(label)
let labelString = String(data: labelData, encoding: .utf8)!

// MARK: JSON -> Model
let sameLabel = try decoder.decode(Label.self, from: labelData)
