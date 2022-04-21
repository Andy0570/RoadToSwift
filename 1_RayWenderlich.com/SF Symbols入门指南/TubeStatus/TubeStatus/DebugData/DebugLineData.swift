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

import Foundation
import SwiftUI

// 1
let bakerlooLineDebug = LineData(
    name: "BakerlooDebug",
    color: Color(red: 137 / 255, green: 78 / 255, blue: 36 / 255))
let centralLineDebug = LineData(
    name: "CentralDebug",
    color: Color(red: 220 / 255, green: 36 / 255, blue: 31 / 255))
let circleLineDebug = LineData(
    name: "CircleDebug",
    color: Color(red: 255 / 255, green: 206 / 255, blue: 0 / 255))
let districtLineDebug = LineData(
    name: "DistrictDebug",
    color: Color(red: 0 / 255, green: 114 / 255, blue: 41 / 255))
let hammersmithAndCityLineDebug = LineData(
    name: "Hammersmith & CityDebug",
    color: Color(red: 215 / 255, green: 153 / 255, blue: 175 / 255))
let jubileeLineDebug = LineData(
    name: "JubileeDebug",
    color: Color(red: 106 / 255, green: 114 / 255, blue: 120 / 255))
let metropolitanLineDebug = LineData(
    name: "MetropolitanDebug",
    color: Color(red: 117 / 255, green: 16 / 255, blue: 86 / 255))
let northernLineDebug = LineData(
    name: "NorthernDebug",
    color: Color(red: 0 / 255, green: 0 / 255, blue: 0 / 255))
let piccadillyLineDebug = LineData(
    name: "PiccadillyDebug",
    color: Color(red: 0 / 255, green: 25 / 255, blue: 168 / 255))
let victoriaLineDebug = LineData(
    name: "VictoriaDebug",
    color: Color(red: 0 / 255, green: 160 / 255, blue: 226 / 255))

let debugData = AllLinesStatus(
    lastUpdated: Date(),
    linesStatus: [
        // 2
        LineStatus(line: bakerlooLine, status: .specialService),
        LineStatus(line: centralLine, status: .closed),
        LineStatus(line: circleLine, status: .suspended),
        LineStatus(line: districtLine, status: .partSuspended),
        LineStatus(line: hammersmithAndCityLine, status: .plannedClosure),
        LineStatus(line: jubileeLine, status: .partClosure),
        LineStatus(line: metropolitanLine, status: .severeDelays),
        LineStatus(line: northernLine, status: .reducedService),
        LineStatus(line: piccadillyLine, status: .busService),
        LineStatus(line: victoriaLine, status: .minorDelays),
        LineStatus(line: waterlooAndCityLine, status: .goodService),
        LineStatus(line: dlr, status: .partClosed),
        // 3
        LineStatus(line: bakerlooLineDebug, status: .exitOnly),
        LineStatus(line: centralLineDebug, status: .noStepFreeAccess),
        LineStatus(line: circleLineDebug, status: .changeOfFrequency),
        LineStatus(line: districtLineDebug, status: .diverted),
        LineStatus(line: hammersmithAndCityLineDebug, status: .notRunning),
        LineStatus(line: jubileeLineDebug, status: .issuesReported),
        LineStatus(line: metropolitanLineDebug, status: .noIssues),
        LineStatus(line: northernLineDebug, status: .information),
        LineStatus(line: piccadillyLineDebug, status: .serviceClosed),
        LineStatus(line: victoriaLineDebug, status: .unknown)
    ]
)
