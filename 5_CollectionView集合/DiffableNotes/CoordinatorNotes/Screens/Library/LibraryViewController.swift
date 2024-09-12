//
//  LibraryViewController.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 27/11/2020.
//

import UIKit
import Combine

class LibraryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var tokens = [AnyCancellable]()
    
    private lazy var viewModel = LibraryViewModel(collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = viewModel.makeDataSource()
        collectionView.delegate = viewModel
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 100)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController, let dest = nav.viewControllers.first as? NewNoteViewController else { fatalError() }
        
        // I chose to use Combine's Publisher pattern for communication, but feel free to use any of your other favorite communication patterns such as delegates or closures.
        dest.notePublisher.sink { [unowned self] note in
            viewModel.add([note])
        }
        .store(in: &tokens)
    }
}

