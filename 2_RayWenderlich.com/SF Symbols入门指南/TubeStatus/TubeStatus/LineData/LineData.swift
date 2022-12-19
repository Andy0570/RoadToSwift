/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

// Static line data that doesn't change (Name, color)
struct LineData {
  let name: String
  let color: Color
}

let bakerlooLine = LineData(name: "Bakerloo", color: Color(red: 137 / 255, green: 78 / 255, blue: 36 / 255))
let centralLine = LineData(name: "Central", color: Color(red: 220 / 255, green: 36 / 255, blue: 31 / 255))
let circleLine = LineData(name: "Circle", color: Color(red: 255 / 255, green: 206 / 255, blue: 0 / 255))
let districtLine = LineData(name: "District", color: Color(red: 0 / 255, green: 114 / 255, blue: 41 / 255))
let hammersmithAndCityLine = LineData(
  name: "Hammersmith & City",
  color: Color(red: 215 / 255, green: 153 / 255, blue: 175 / 255)
)
let jubileeLine = LineData(name: "Jubilee", color: Color(red: 106 / 255, green: 114 / 255, blue: 120 / 255))
let metropolitanLine = LineData(name: "Metropolitan", color: Color(red: 117 / 255, green: 16 / 255, blue: 86 / 255))
let northernLine = LineData(name: "Northern", color: Color(red: 0 / 255, green: 0 / 255, blue: 0 / 255))
let piccadillyLine = LineData(name: "Piccadilly", color: Color(red: 0 / 255, green: 25 / 255, blue: 168 / 255))
let victoriaLine = LineData(name: "Victoria", color: Color(red: 0 / 255, green: 160 / 255, blue: 226 / 255))
let waterlooAndCityLine = LineData(
  name: "Waterloo & City Line", color: Color(red: 118 / 255, green: 208 / 255, blue: 189 / 255)
)
let dlr = LineData(name: "DLR", color: Color(red: 0 / 255, green: 175 / 255, blue: 173 / 255))
