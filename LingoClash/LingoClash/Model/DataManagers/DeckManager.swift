//
//  DeckManager.swift
//  LingoClash
//
//  Created by kevin chua on 15/4/22.
//

import Foundation
import PromiseKit

class DeckManager: DataManager<DeckData> {
    
    init() {
        super.init(resource: "decks")
    }
    
    func addDeck(newDeckFields: CreateDeckFields) {
        firstly {
            ProfileManager().getCurrentProfile()
        }.done { currentProfile in
            self.create(newRecord:
                            DeckData(id: "-1", name: newDeckFields.newName, profile_id: currentProfile.id, revision_vocab_id: [])
            )
        }
    }
    
    
    func getDecks(profileId: Identifier) -> Promise<[Deck]> {
        var revisionVocabByDeckData: [DeckData: [RevisionVocabData]] = [:]
        var vocabByDeckData: [DeckData: [VocabData]] = [:]
        // .then to chain it to VocabByDeckId
        // take in [DeckData], [VocabByDeckId] -> [Deck]

        return firstly {
            // first, fetch decks
            DeckManager().getManyReference(target: "profile_id", id: profileId)
        }.then { deckDataArr -> Promise<Void> in
            let revisionVocabPromises = deckDataArr.map { deckData in
                firstly {
                    RevisionVocabManager().getManyReference(target: "deck_id", id: deckData.id)
                }.done { revisionVocabsData in
                    revisionVocabByDeckData[deckData] = revisionVocabsData
                }
            }
            // returns [RevisionVocabData]
            return when(fulfilled: revisionVocabPromises)
        }.then { _ -> Promise<Void> in
            var vocabPromises = [Promise<Void>]()
            // [Promise<VocabData>]
            for (deckData, revisionVocabData) in revisionVocabByDeckData {
                guard revisionVocabData.count > 0 else {
                    vocabByDeckData[deckData] = []
                    continue
                }
//                print(revisionVocabData)
                vocabPromises.append(
                    firstly {
                        VocabManager().getMany(ids: revisionVocabData.map{$0.id})
                    }.done { vocabData in
                        vocabByDeckData[deckData] = vocabData
                    }
                )
            }
            return when(fulfilled: vocabPromises)
        }.map { () -> [Deck] in
            var deckArr = [Deck]()
            // convert [DeckData] into
            for (deckData, vocabData) in vocabByDeckData {
                deckArr.append(Deck(deckData: deckData, vocabDataArr: vocabData))
            }
            return deckArr
        }
    }
    
}
