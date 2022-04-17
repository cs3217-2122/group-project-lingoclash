//
//  RevisionViewModel.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//

import Combine
import PromiseKit

final class RevisionViewModel {
    
    @Published var decks: [Deck] = []
    @Published var isRefreshing = false
    
    // Criteria for RevisionQueries to appear in decks
    public static let REVISION_QUERY_CRITERIA = { (revisionQuery: RevisionQuery) -> Bool in
        return revisionQuery.magnitude < 2
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
    
    func addDeck(_ deckFields: CreateDeckFields) {
        decks.append(Deck(name: deckFields.newName, vocabs: []))
    }
}
