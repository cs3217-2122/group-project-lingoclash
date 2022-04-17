//
//  AddToDeckTableView.swift
//  LingoClash
//
//  Created by kevin chua on 17/4/22.
//

import UIKit
import Combine

private let reuseIdentifier = "AddToDeckTableViewCell"

class AddToDeckTableView: UITableViewController {
    var viewModel: AddToDeckViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    private var decks: [Deck]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBinders()
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.fetchDecks()
    }
    
    private func setUpBinders() {
        viewModel?.$decks.sink {[weak self] decks in
            self?.decks = decks
            // initialise decks progress as well
            
            self?.tableView.reloadData()
        }.store(in: &cancellables)
        
        viewModel?.$isRefreshing.sink {[weak self] isRefreshing in
            if isRefreshing {
                self?.parent?.showSpinner()
            } else {
                self?.parent?.removeSpinner()
            }
        }.store(in: &cancellables)
    }
}

extension AddToDeckTableView {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        decks?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let deckCell = tableView
                .dequeueReusableCell(
                    withIdentifier: reuseIdentifier) as? AddToDeckTableViewCell else {
            fatalError("Failure obtaining reusable vocabs learnt table view cell")
        }
        guard let decks = self.decks else {
            return deckCell
        }

        deckCell.configure(
            deckName: decks[indexPath.row].name
        )

        return deckCell
    }
}

extension AddToDeckTableView {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let deck = decks?[indexPath.row] else {
            return
        }
        
        self.viewModel?.addVocabToDeck(deck: deck)
        // set it to the correct viewmodel
//        let selectedDeck = decks?[indexPath.row]
//        self.selectedDeck = selectedDeck
//
//        // then do a segue
//        performSegue(withIdentifier: Segue.gotoDeck, sender: self)
    }
}
