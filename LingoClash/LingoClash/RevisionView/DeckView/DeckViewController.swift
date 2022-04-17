//
//  DeckViewController.swift
//  LingoClash
//
//  Created by kevin chua on 12/4/22.
//

import UIKit
import Combine

class DeckViewController: UIViewController {

    var viewModel: DeckViewModel?
    private var deck: Deck?
    private var revisionSequence: QuerySequence?
    private var currentQuery: RevisionQuery?
    
    @IBOutlet weak var contextLabel: UILabel!
    
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var wordsLeftLabel: UILabel!
    
    // No more words screen
    @IBOutlet weak var noWordsBackground: UIImageView!
    @IBOutlet weak var noWordsImage: UIImageView!
    @IBOutlet weak var noWordsLabel1: UILabel!
    @IBOutlet weak var noWordsLabel2: UILabel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideAnswer()
        hideNoWordsScreen()
        showScreenWhenNoWordsLeft()
        setUpBinders()
        getFirstQuery()
    }
    
    private func setUpBinders() {
        viewModel?.$deck.sink {[weak self] deck in
            self?.deck = deck
        }.store(in: &cancellables)
        
        viewModel?.$revisionSequence.sink {[weak self] revisionSequence in
            self?.revisionSequence = revisionSequence
            self?.updateWordsLeft()
            self?.showScreenWhenNoWordsLeft()
        }.store(in: &cancellables)
    }
    
    private func updateWordsLeft() {
        // We add 1 because we take into account the word currently being shown too
        wordsLeftLabel.text = "Words Left: \(revisionSequence?.questionsLeft ?? 0 + 1)"
    }

    private func getFirstQuery() {
        let firstQuery = viewModel?.getNextQuery()
        contextLabel.text = firstQuery?.context
        
        exampleLabel.text = firstQuery?.revVocab.vocab.sentence
        answerLabel.text = firstQuery?.answerToString
        
        self.currentQuery = firstQuery
    }

    @IBOutlet weak var showAnswerButton: UIButton!

    @IBAction func answerDidTap(_ sender: Any) {
        hideAnswerButton()
        showAnswer()
    }
    
    func recallDifficultyButtonTapped() {
        unhideAnswerButton()
        hideAnswer()
        // Check if we have 0 words left
        
        showScreenWhenNoWordsLeft()
    }
    
    private func showScreenWhenNoWordsLeft() {
        if revisionSequence?.questionsLeft == 0 {
            showNoWordsScreen()
        }
    }
    
    private func hideNoWordsScreen() {
        noWordsBackground.isHidden = true
        noWordsImage.isHidden = true
        noWordsLabel1.isHidden = true
        noWordsLabel2.isHidden = true
    }
    
    private func showNoWordsScreen() {
        noWordsBackground.isHidden = false
        noWordsImage.isHidden = false
        noWordsLabel1.isHidden = false
        noWordsLabel2.isHidden = false
    }

    @IBOutlet weak var againButton: UIButton!
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    
    @IBOutlet weak var hardButton: UIButton!
    
    @IBAction func againDidTap(_ sender: Any) {
        
        viewModel?.addToQueue(currentQuery: currentQuery, recallDifficulty: .again)
        viewModel?.updateRevisionQuery(query: currentQuery)
        
        let nextQuery = viewModel?.getNextQuery()
        self.currentQuery = nextQuery
        
        setLabelToQuery(query: nextQuery)
        recallDifficultyButtonTapped()
    }
    
    @IBAction func hardDidTap(_ sender: Any) {
        
        viewModel?.addToQueue(currentQuery: currentQuery, recallDifficulty: .hard)
        
        let nextQuery = viewModel?.getNextQuery()
        self.currentQuery = nextQuery
        
        setLabelToQuery(query: nextQuery)
        recallDifficultyButtonTapped()
    }
    
    @IBAction func easyDidTap(_ sender: Any) {
        
        viewModel?.addToQueue(currentQuery: currentQuery, recallDifficulty: .easy)
        
        let nextQuery = viewModel?.getNextQuery()
        self.currentQuery = nextQuery
        
        setLabelToQuery(query: nextQuery)
        recallDifficultyButtonTapped()
    }
    
    @IBAction func goodDidTap(_ sender: Any) {
        viewModel?.addToQueue(currentQuery: currentQuery, recallDifficulty: .good)
        
        let nextQuery = viewModel?.getNextQuery()
        self.currentQuery = nextQuery
        
        setLabelToQuery(query: nextQuery)
        recallDifficultyButtonTapped()
    }
    
    private func setLabelToQuery(query: RevisionQuery?) {
        contextLabel.text = query?.context
        answerLabel.text = query?.revVocab.vocab.definition
        exampleLabel.text = query?.revVocab.vocab.sentence
    }
    
    // View specific functions
    private func hideRecallButtons() {
        againButton.isHidden = true
        easyButton.isHidden = true
        goodButton.isHidden = true
        hardButton.isHidden = true
    }
    
    private func showRecallButtons() {
        againButton.isHidden = false
        easyButton.isHidden = false
        goodButton.isHidden = false
        hardButton.isHidden = false
    }
        
    private func hideAnswerButton() {
        showAnswerButton.isHidden = true
    }
    
    private func unhideAnswerButton() {
        showAnswerButton.isHidden = false
    }
    
    private func showAnswer() {
        exampleLabel.isHidden = false
        answerLabel.isHidden = false
    }
    
    private func hideAnswer() {
        exampleLabel.isHidden = true
        answerLabel.isHidden = true
    }
    
}
