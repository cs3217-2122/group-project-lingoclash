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
    
    private static let DEFAULT_DECK_NAME = "Default Deck"
    
    func addDefaultDeck() {
        decks.append(
            Deck(
                name: RevisionViewModel.DEFAULT_DECK_NAME,
                vocabs: createRevisionVocabs()
            )
        )
    }
    
    func createRevisionVocabs() -> [RevisionVocab] {
        let vocabs = [
            Vocab(vocabId: 1, word: "周", definition: "week", sentence: "一周有七天。",
                  sentenceDefinition: "Every week has 7 days.", pronunciationText: "zhōu"),
            Vocab(vocabId: 2, word: "今天", definition: "today", sentence: "她今天看起来很悲伤。",
                  sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            Vocab(vocabId: 3, word: "明天", definition: "tomorrow", sentence: "明天10：10",
                  sentenceDefinition: " tomorrow at 10:10", pronunciationText: "míngtiān"),
            Vocab(vocabId: 4, word: "昨天", definition: "yesterday", sentence: "她昨天看起来很悲伤。",
                  sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            Vocab(vocabId: 5, word: "日历", definition: "calendar", sentence: "她今天看起来很日历。",
                  sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān"),
            Vocab(vocabId: 6, word: "秒", definition: "second", sentence: "她秒看起来很悲伤。",
                  sentenceDefinition: "She looks saf today.", pronunciationText: "jīntiān")
        ]
        var vocabArr: [RevisionVocab] = []
        
        for vocab in vocabs {
            vocabArr.append(
                RevisionVocab(vocab: vocab, difficultyParameter: Difficulty(amount: 0))
            )
        }
        
        return vocabArr
    }

    func fetchDecks() {
        if self.isRefreshing {
            return
        }
        
        self.isRefreshing = true
        
        firstly {
            ProfileManager().getCurrentProfile()
        }.then { currentProfile in
            DeckManager().getDecks(profileId: currentProfile.id)
        }.done { deckArr in
            self.decks.append(contentsOf: deckArr)
            self.isRefreshing = false
        }.catch { error in
            print(error)
        }

        addDefaultDeck()
    }
    
    func stopRefresh() {
        self.isRefreshing = false
    }
    
    func deckProgress() {
        
    }
    
    func addDeck(_ deckFields: CreateDeckFields) {
        // update locally
        decks.append(Deck(name: deckFields.newName, vocabs: []))
    }
}
