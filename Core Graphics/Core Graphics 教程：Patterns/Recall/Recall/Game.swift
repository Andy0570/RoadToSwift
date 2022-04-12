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
/// THE SOFTWARE

import UIKit

class Game {
  // MARK: - Properties
  let maxAttemptsAllowed = 5
  let colorSelections: [UIColor] = [.blue, .red, .magenta]
  let totalPatternCount: Int

  var score: Int
  var attempt: Int
  var answers: [PatternView.PatternDirection]

  private var majorityPatternCount: Int {
    return totalPatternCount / 2 + 1
  }

  // MARK: - Object Lifecycle
  init(patternCount count: Int) {
    totalPatternCount = count
    score = 0
    attempt = 0
    answers = []
  }

  // MARK: - Gameplay
  func play(_ guess: PatternView.PatternDirection) -> (correct: Bool, score: Int)? {
    if done() {
      return nil
    }
    if guess == answers[attempt] {
      score += 1
      attempt += 1
      return (true, score)
    } else {
      attempt += 1
      return (false, score)
    }
  }

  func setupNextPlay() -> (directions: [PatternView.PatternDirection], colors: [UIColor]) {
    var directions: [PatternView.PatternDirection] = []
    var colors: [UIColor] = []

    // Get a list of directions that don't belong to the correct answer
    let wrongDirections = PatternView.PatternDirection.allCases.filter {
      $0 != answers[attempt]
    }
    // Get a random number of correct answers to fill, to maintain the majority
    let numberOfCorrectPatterns = Int.random(in: majorityPatternCount ..< totalPatternCount)

    // Fill out the return info
    for index in 0..<totalPatternCount {
      // Front load with the correct answer
      if index < numberOfCorrectPatterns {
        directions.append(answers[attempt])
      } else {
        // Next, randomly assign wrong answers
        if let randomDirection = wrongDirections.randomElement() {
          directions.append(randomDirection)
        }
      }
      // Pick a random color for the pattern
      if let randomColor = colorSelections.randomElement() {
        colors.append(randomColor)
      }
    }
    // Randomly reorder the directions
    directions.shuffle()

    return (directions, colors)
  }

  func done() -> Bool {
    return attempt >= maxAttemptsAllowed
  }

  func reset() {
    score = 0
    attempt = 0
    answers.removeAll()

    generatePlays()
  }
}

// MARK: - Private methods
private extension Game {
  func generatePlays() {
    // Pick the random direction that will be the dominant one
    let allPatternDirections = PatternView.PatternDirection.allCases
    answers = (0..<maxAttemptsAllowed).map { _ in
      // swiftlint:disable:next force_unwrapping
      allPatternDirections.randomElement()!
    }
  }
}
