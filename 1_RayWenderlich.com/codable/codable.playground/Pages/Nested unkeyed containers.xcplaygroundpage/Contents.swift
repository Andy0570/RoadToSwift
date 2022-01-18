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

struct Toy: Encodable {
    var name: String
    var label: String

    enum CodingKeys: CodingKey {
        case name, label
    }

    // MARK: 自定义编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)

        var labelContainer = container.nestedUnkeyedContainer(forKey: .label)
        try labelContainer.encode(name.lowercased())
        try labelContainer.encode(name.uppercased())
        try labelContainer.encode(name)
    }
}

extension Toy: Decodable {
    // MARK: 自定义解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)

        var labelContainer = try container.nestedUnkeyedContainer(forKey: .label)
        var labelName = ""
        while !labelContainer.isAtEnd {
            labelName = try labelContainer.decode(String.self)
        }
        label = labelName
    }
}

let toy = Toy(name: "Teddy Bear", label: "Teddy Bear")

let encoder = JSONEncoder()
let decoder = JSONDecoder()

// MARK: Model -> JSON
let data = try encoder.encode(toy)
let string = String(data: data, encoding: .utf8)!

// MARK: JSON -> Model
let sameToy = try decoder.decode(Toy.self, from: data)
