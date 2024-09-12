//
//  NewNoteViewController.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 28/11/2020.
//

import UIKit
import Combine

class NewNoteViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    public var notePublisher = PassthroughSubject<Note, Never>()
    
    private var note: Note {
        Note(text: textView.text)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        // I chose to use Combine's Publisher pattern for communication, but feel free to use any of your other favorite communication patterns such as delegates or closures.
        notePublisher.send(note)
        
        dismiss(animated: true, completion: nil)
    }
}
