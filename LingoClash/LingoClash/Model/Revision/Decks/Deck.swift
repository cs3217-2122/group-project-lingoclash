//
//  Deck.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//

struct Deck {
//    var id: Identifier
    let name: String
    var vocabs: [RevisionQuery]
    
    // can probably list the easy, med, hard vocabs next time
    var vocabNo: Int {
        get {
            vocabs.count
        }
    }
    
    init(name: String, vocabs: [RevisionVocab]) {
        self.name = name
        
        self.vocabs = vocabs.map{ RevisionQuery(vocab: $0, context: $0.vocab.word, answer: $0.vocab.definition, id: "-1")
        }
    }
    
    init(deckData: DeckData, vocabDataArr: [VocabData]) {
        self.name = deckData.name

        
        self.vocabs = vocabDataArr.map{ vocabData in
            let revisionVocab = RevisionVocab(vocab: Vocab(vocabData: vocabData), difficultyParameter: Difficulty(amount: 0))
            return RevisionQuery(vocab: revisionVocab,
                                 context: vocabData.word,
                                 answer: vocabData.definition,
                                 difficulty: Difficulty(amount: 0),
                                 lastAttemptedDate: nil,
                                 id: "-1")
        }
    }
}

extension Deck: Codable {}

