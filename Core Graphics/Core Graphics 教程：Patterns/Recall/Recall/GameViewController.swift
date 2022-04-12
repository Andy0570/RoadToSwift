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

class GameViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var item1PatternView: PatternView!
    @IBOutlet weak var item2PatternView: PatternView!
    @IBOutlet weak var item3PatternView: PatternView!
    @IBOutlet weak var item4PatternView: PatternView!

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    @IBOutlet weak var choiceFeedbackLabel: UILabel!

    // MARK: - Properties
    let numberOfPatterns = 4
    var game: Game?
    var score: Int? {
        didSet {
            if let score = score, let game = game {
                scoreLabel.text = "\(score) / \(game.maxAttemptsAllowed)"
            }
        }
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game(patternCount: numberOfPatterns)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        game?.reset()
        score = game?.score
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNextPlay()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue" {
            if let destinationViewController = segue.destination as? ResultViewController {
                destinationViewController.score = score
            }
        }
    }

    // MARK: - Actions
    @IBAction func choiceButtonPressed(_ sender: UIButton) {
        switch sender {
        case leftButton:
            play(.left)
        case topButton:
            play(.top)
        case bottomButton:
            play(.bottom)
        case rightButton:
            play(.right)
        default:
            play(.left)
        }
    }
}

// MARK: - Private methods
private extension GameViewController {
    func showNextPlay() {
        guard let game = game else { return }
        // Check if the game is still in progress
        if !game.done() {
            // Get the next set of directions and colors for the pattern views
            let (directions, colors) = game.setupNextPlay()
            // Update the pattern views
            setupPatternView(item1PatternView, towards: directions[0], havingColor: colors[0])
            setupPatternView(item2PatternView, towards: directions[1], havingColor: colors[1])
            setupPatternView(item3PatternView, towards: directions[2], havingColor: colors[2])
            setupPatternView(item4PatternView, towards: directions[3], havingColor: colors[3])
            // Re-enable the buttons and hide the answer feedback
            controlsEnabled(true)
        }
    }

    // swiftlint:disable:next identifier_name
    func controlsEnabled(_ on: Bool) {
        // Enable or disable the buttons
        leftButton.isEnabled = on
        topButton.isEnabled = on
        bottomButton.isEnabled = on
        rightButton.isEnabled = on
        // Show or hide the feedback on the answer
        choiceFeedbackLabel.isHidden = on
    }

    // Sets up the pattern view given a diretion and color
    func setupPatternView(_ patternView: PatternView, towards: PatternView.PatternDirection, havingColor color: UIColor) {
        patternView.direction = towards
        patternView.fillColor = color.rgba
        patternView.setNeedsDisplay() // 提示系统重新绘制图案
    }

    // Displays the results of the choice
    func displayResults(_ correct: Bool) {
        if correct {
            print("You answered correctly!")
            choiceFeedbackLabel.text = "\u{2713}" // checkmark
            choiceFeedbackLabel.textColor = .green
        } else {
            print("That one got you.")
            choiceFeedbackLabel.text = "\u{2718}" // wrong (X)
            choiceFeedbackLabel.textColor = .red
        }
        // Visual indicator of correctness
        UIView.animate(withDuration: 0.5) {
            self.choiceFeedbackLabel.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.choiceFeedbackLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }

    // Processes the play and displays the result
    func play(_ selection: PatternView.PatternDirection) {
        // Temporarily disable the buttons and make the feedback label visible
        controlsEnabled(false)
        // Check if the answer is correct
        if let result = game?.play(selection) {
            // Update the score
            score = result.score
            // Show whether the answer is correct or not
            displayResults(result.correct)
        }
        // Wait a little before showing the next play or transition to the
        // end game view
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if self.game?.done() == true {
                self.performSegue(withIdentifier: "resultSegue", sender: nil)
            } else {
                self.showNextPlay()
            }
        }
    }
}

// MARK: - UIColor extension
extension UIColor {
    // Returns an array that splits out the RGB and Alpha values
    var rgba: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [red, green, blue, alpha]
    }
}
