/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


// NOTE:
// You can find the definition of Music and Instrument types using the file
// navigator and looking in the Sources folder for MusicFramework.swift
// Swift files put here are built as a separate module imported into all
// playground pages.

// 钢琴
class Piano: Instrument {
  let hasPedals: Bool
  static let whiteKeys = 52
  static let blackKeys = 36
  
  init(brand: String, hasPedals: Bool = false) {
    self.hasPedals = hasPedals
    super.init(brand: brand)
  }
  
  override func tune() -> String {
    return "Piano standard tuning for \(brand)."
  }
  
  override func play(_ music: Music) -> String {
    return play(music, usingPedals: hasPedals)
  }
  
  func play(_ music: Music, usingPedals: Bool) -> String {
    let preparedNotes = super.play(music)
    if hasPedals && usingPedals {
      return "Play piano notes \(preparedNotes) with pedals."
    }
    else {
      return "Play piano notes \(preparedNotes) without pedals."
    }
  }
}

let piano = Piano(brand: "Yamaha", hasPedals: true)
piano.tune()
let music = Music(notes: ["C", "G", "F"])
piano.play(music, usingPedals: false)
piano.play(music)
Piano.whiteKeys
Piano.blackKeys

// 吉他
class Guitar: Instrument {
  let stringGauge: String
  
  init(brand: String, stringGauge: String = "medium") {
    self.stringGauge = stringGauge
    super.init(brand: brand)
  }
}

// 原声吉他
class AcousticGuitar: Guitar {
  static let numberOfStrings = 6
  static let fretCount = 20
  
  override func tune() -> String {
    return "Tune \(brand) acoustic with E A D G B E"
  }
  
  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play folk tune on frets \(preparedNotes)."
  }
}

let acousticGuitar = AcousticGuitar(brand: "Roland", stringGauge: "light")
acousticGuitar.tune()
acousticGuitar.play(music)

// 放大器
class Amplifier {
  private var _volume: Int
  private(set) var isOn: Bool

  init() {
    isOn = false
    _volume = 0
  }

  func plugIn() {
    isOn = true
  }

  func unplug() {
    isOn = false
  }

  var volume: Int {
    get {
      return isOn ? _volume : 0
    }
    set {
      _volume = min(max(newValue, 0), 10)
    }
  }
}

// 电子吉他
class ElectricGuitar: Guitar {
  let amplifier: Amplifier
  static let numberOfStrings = 6
  static let fretCount = 24
  
  init(brand: String, stringGauge: String = "light", amplifier: Amplifier) {
    self.amplifier = amplifier
    super.init(brand: brand, stringGauge: stringGauge)
  }
  
  override func tune() -> String {
    amplifier.plugIn()
    amplifier.volume = 5
    return "Tune \(brand) electric with E A D G B E"
  }
  
  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play solo \(preparedNotes) at volume \(amplifier.volume)."
  }
}

// 贝斯吉他
class BassGuitar: Guitar {
  let amplifier: Amplifier
  static let numberOfStrings = 4
  static let fretCount = 24

  init(brand: String, stringGauge: String = "heavy", amplifier: Amplifier) {
    self.amplifier = amplifier
    super.init(brand: brand, stringGauge: stringGauge)
  }

  override func tune() -> String {
    amplifier.plugIn()
    return "Tune \(brand) bass with E A D G"
  }

  override func play(_ music: Music) -> String {
    let preparedNotes = super.play(music)
    return "Play bass line \(preparedNotes) at volume \(amplifier.volume)."
  }
}

// !!!: 类遵循引用语义
let amplifier = Amplifier()
let electricGuitar = ElectricGuitar(brand: "Gibson", stringGauge: "medium", amplifier: amplifier)
electricGuitar.tune()

let bassGuitar = BassGuitar(brand: "Fender", stringGauge: "heavy", amplifier: amplifier)
bassGuitar.tune()

// Notice that because of class reference semantics, the amplifier is a shared
// resource between these two guitars.

bassGuitar.amplifier.volume
electricGuitar.amplifier.volume

bassGuitar.amplifier.unplug()
bassGuitar.amplifier.volume
electricGuitar.amplifier.volume

bassGuitar.amplifier.plugIn()
bassGuitar.amplifier.volume
electricGuitar.amplifier.volume

// 乐队
final class Band {
  let instruments: [Instrument]
  
  init(instruments: [Instrument]) {
    self.instruments = instruments
  }
  
  func perform(_ music: Music) {
    for instrument in instruments {
      instrument.perform(music)
    }
  }
}

// 多态类型
let instruments = [piano, acousticGuitar, electricGuitar, bassGuitar]
let band = Band(instruments: instruments)
band.perform(music)













