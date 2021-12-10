//
//  MoodSelectionViewController.swift
//  Mandala
//
//  Created by Qilin Hu on 2021/12/8.
//

import UIKit

class MoodSelectionViewController: UIViewController {

    @IBOutlet var moodSelector: ImageSelector!
    @IBOutlet var addMoodButton: UIButton!
    
    var moodsConfigurable: MoodsConfigurable!
    
    var moods: [Mood] = [] {
        didSet {
            moodSelector.images = moods.map { $0.image }
            moodSelector.highlightColors = moods.map { $0.color }
            
            currentMood = moods.first
        }
    }
    
    var currentMood: Mood? {
        didSet {
            guard let currentMood = currentMood else {
                addMoodButton?.setTitle(nil, for: .normal)
                addMoodButton?.backgroundColor = nil
                return
            }
            
            addMoodButton?.setTitle("I'm \(currentMood.name)", for: .normal)
            
            // Animating a Button
            let selectionAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.7) {
                self.addMoodButton?.backgroundColor = currentMood.color
            }
            selectionAnimator.startAnimation()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moods = [.happy, .sad, .angry, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }

    
    // MARK: - Actions
    
    @IBAction private func moodSelectionChanged(_ sender: ImageSelector) {
        let selectedIndex = sender.selectedIndex
        
        currentMood = moods[selectedIndex]
    }
    
    @IBAction func addMoodTapped(_ sender: Any) {
        guard let currentMood = currentMood else {
            return
        }
        
        let newMoodEntry = MoodEntry(mood: currentMood, timestamp: Date())
        moodsConfigurable.add(newMoodEntry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "embedContainerViewController":
            guard let moodsConfigurable = segue.destination as? MoodsConfigurable else {
                preconditionFailure("View controller expected to conform to MoodsConfigurable")
            }
            self.moodsConfigurable = moodsConfigurable
            segue.destination.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

