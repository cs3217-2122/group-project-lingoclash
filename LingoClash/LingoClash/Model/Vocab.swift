//
//  Vocab.swift
//  LingoClash
//
//  Created by Sherwin Poh on 19/3/22.
//

import Foundation

struct Vocab {
    let id: Identifier
    let word: String
    let definition: String
    let sentence: String
    let sentenceDefinition: String
    let pronunciationText: String
    // TODO: Add pronunciation
    
    init(vocabData: VocabData) {
        self.id = vocabData.id
        self.word = vocabData.word
        self.definition = vocabData.definition
        self.sentence = vocabData.sentence
        // TODO: add to firebase
        self.sentenceDefinition = ""
        self.pronunciationText = ""
    }
}

extension Vocab: Codable {}
extension Vocab: Hashable {}
