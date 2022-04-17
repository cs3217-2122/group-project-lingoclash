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

    init(
        word: String,
        definition: String,
        sentence: String,
        sentenceDefinition: String,
        pronunciationText: String,
        id: Identifier = "-1") {
        self.id = id
        self.word = word
        self.definition = definition
        self.sentence = sentence
        self.sentenceDefinition = sentenceDefinition
        self.pronunciationText = pronunciationText
    }

    init(vocabData: VocabData) {
        self.id = vocabData.id
        self.word = vocabData.word
        self.definition = vocabData.definition
        self.sentence = vocabData.sentence
        self.sentenceDefinition = vocabData.translation
        self.pronunciationText = vocabData.pronunciation_text
    }
    
    // To be removed
    init(vocabId: Int, word: String, definition: String, sentence: String, sentenceDefinition: String, pronunciationText: String ) {
        self.word = word
        self.definition = definition
        self.sentence = sentence
        self.sentenceDefinition = sentenceDefinition
        self.pronunciationText = pronunciationText
        self.id = "1"
    }

}

extension Vocab: Codable {}
extension Vocab: Hashable {}
