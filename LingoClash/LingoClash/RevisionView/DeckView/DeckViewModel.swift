//
//  DeckViewModel.swift
//  LingoClash
//
//  Created by kevin chua on 13/4/22.
//

import Foundation
import PromiseKit

final class DeckViewModel {
    
    @Published var deck: Deck
    
    @Published var revisionSequence: RevisionSequence

    init(deck: Deck) {
        self.deck = deck
        self.revisionSequence = RevisionSequence(
            deck: deck,
            criteria: RevisionViewModel.REVISION_QUERY_CRITERIA
        )
    }

    func addToQueue(currentQuery: RevisionQuery?, recallDifficulty: RecallDifficulty) {
        guard let currentQuery = currentQuery else {
            return
        }
        
        // make the question go back to the queue with the specified difficulty
        let newQuery = RevisionQuery(
            vocab: currentQuery.revVocab,
            difficulty: Difficulty(amount: recallDifficulty.rawValue),
            lastAttemptedDate: Date()
        )
        
        self.revisionSequence.insert(newQuery)
    }

    func getNextQuery() -> RevisionQuery? {
        let nextQuery = revisionSequence.next() as? RevisionQuery
        return nextQuery
    }
    
    func updateRevisionQuery(query: RevisionQuery?, recallDifficulty: RecallDifficulty) {
        guard let query = query else {
            return
        }
        
        let currDate = Date()
        
        firstly {
            // get the id
            RevisionVocabManager().getOne(id: query.revVocab.id)
        }.then { revisionVocabData in
            RevisionVocabManager().update(id: query.revVocab.id,
                                          to: RevisionVocabData(id: query.revVocab.id,
                                                                difficulty: recallDifficulty.rawValue,
                                                                last_attempted_date: currDate,
                                                                vocab_id: query.revVocab.vocab.id,
                                                                deck_id: revisionVocabData.deck_id))
        }.done { _ in
            Logger.info(
                "Revision Vocab \(query.revVocab.vocab.word) has been updated with latest attempt at \(currDate)"
            )
        }.catch { error in
            Logger.error("\(error)")
        }
    }
}
