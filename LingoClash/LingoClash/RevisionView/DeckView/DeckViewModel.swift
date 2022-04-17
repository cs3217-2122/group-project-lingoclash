//
//  DeckViewModel.swift
//  LingoClash
//
//  Created by kevin chua on 13/4/22.
//

import Foundation

final class DeckViewModel {
    
    @Published var deck: Deck
    
    @Published var revisionSequence: RevisionSequence

    init(deck: Deck) {
        self.deck = deck
        self.revisionSequence = RevisionSequence(deck: deck)
    }
    
    func addToQueue(currentQuery: RevisionQuery?, recallDifficulty: RecallDifficulty) {
        guard let currentQuery = currentQuery else {
            return
        }
        
        // make the question go back to the queue with the specified difficulty
        let newQuery = RevisionQuery(
            vocab: currentQuery.revVocab,
            context: currentQuery.context,
            answer: currentQuery.answerToString,
            difficulty: Difficulty(amount: recallDifficulty.rawValue),
            lastAttemptedDate: Date(),
            id: currentQuery.id
        )
        
        self.revisionSequence.insert(newQuery)
    }

//    func tapDifficulty(currentQuery: RevisionQuery?, recallDifficulty: RecallDifficulty) -> RevisionQuery? {
//
//        addToQueue(currentQuery: currentQuery, recallDifficulty: recallDifficulty)
//
//        print(revisionSequence)
//        print(currentQuery.magnitude)
//
//        return revisionSequence.next() as? RevisionQuery
//    }

    func getNextQuery() -> RevisionQuery? {
        let nextQuery = revisionSequence.next() as? RevisionQuery
        return nextQuery
    }
    
    func updateRevisionQuery(query: RevisionQuery?) {
        guard let query = query else {
            return
        }
        
//        RevisionVocabManager().update(id: <#T##Identifier#>, from: <#T##RevisionVocabData#>, to: <#T##RevisionVocabData#>)
    }
    
    
    
    
}
