//
//  RevisionViewController.swift
//  LingoClash
//
//  Created by kevin chua on 26/3/22.
//
import UIKit
import Combine

private let reuseIdentifier = "DeckTableViewCell"

class RevisionViewController: UIViewController {
    enum Segue {
        static let gotoDeck = "gotoDeck"
    }
    
    @IBOutlet weak var revisionTableView: UITableView!
    
    private var decks: [Deck]?
    
    private let viewModel = RevisionViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var selectedDeck: Deck?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBinders()
        revisionTableView.dataSource = self
        revisionTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.decks = []
        self.viewModel.fetchDecks()
    }

    private func setUpBinders() {
        viewModel.$decks.sink {[weak self] decks in
            self?.decks = decks
            // initialise decks progress as well
            
            self?.revisionTableView.reloadData()
        }.store(in: &cancellables)
        
        viewModel.$isRefreshing.sink {[weak self] isRefreshing in
            if isRefreshing {
                self?.parent?.showSpinner()
            } else {
                self?.parent?.removeSpinner()
            }
        }.store(in: &cancellables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createDeckVC = segue.destination as? RevisionCreateDeckViewController {
            createDeckVC.viewModel = self.viewModel
        } else if let deckVC = segue.destination as? DeckViewController {
            guard let selectedDeck = self.selectedDeck else {
                return
            }
            
            deckVC.viewModel = DeckViewModel(deck: selectedDeck)
        }
    }
}

extension RevisionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.decks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let deckCell = tableView
                .dequeueReusableCell(
                    withIdentifier: reuseIdentifier) as? DeckTableViewCell else {
            fatalError("Failure obtaining reusable vocabs learnt table view cell")
        }
        guard let decks = self.decks else {
            return deckCell
        }

        // We create a RevisionSequence at that point to see how many are available
        deckCell.configure(
            deckName: decks[indexPath.row].name,
            vocabNo: String(
                RevisionSequence(deck: decks[indexPath.row],
                                 criteria: RevisionViewModel.REVISION_QUERY_CRITERIA).count()
            )
        )

        return deckCell
    }
}

extension RevisionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // set it to the correct viewmodel
        let selectedDeck = decks?[indexPath.row]
        self.selectedDeck = selectedDeck
        
        // then do a segue
        performSegue(withIdentifier: Segue.gotoDeck, sender: self)
    }
}
