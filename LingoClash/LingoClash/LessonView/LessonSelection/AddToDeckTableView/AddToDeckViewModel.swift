//
//  AddToDeckViewModel.swift
//  LingoClash
//
//  Created by kevin chua on 17/4/22.
//

import Foundation
import PromiseKit

final class AddToDeckViewModel {
    @Published var decks: [Deck] = []
    @Published var isRefreshing = false
    
    var vocab: Vocab
    
    init(vocab: Vocab) {
        self.vocab = vocab
    }
    
    func addVocabToDeck(deck: Deck) {
        let revisionVocabData = RevisionVocabData(id: "-1", difficulty: 0, last_attempted_date: Date(), vocab_id: vocab.id, deck_id: deck.id)
        firstly {
            RevisionVocabManager().create(newRecord: revisionVocabData)
        }.done { _ in
            Logger.info("Successly added \(revisionVocabData) to Deck \(deck)")
        }.catch { error in
            Logger.error("\(error)")
        }
    }

    func fetchDecks() {
        self.decks = []
        self.isRefreshing = true
        
        firstly {
            ProfileManager().getCurrentProfile()
        }.then { currentProfile in
            DeckManager().getDecks(profileId: currentProfile.id)
        }.done { deckArr in
            self.decks.append(contentsOf: deckArr)
            self.isRefreshing = false
        }.catch { error in
            Logger.error("\(error)")
        }
    }
}
