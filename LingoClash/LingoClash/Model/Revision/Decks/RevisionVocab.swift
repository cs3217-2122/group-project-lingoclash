//
//  RevisionVocab.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//

import Foundation

struct RevisionVocab {
//    var id: Identifier
    var difficultyParameter: Difficulty
    var lastAttemptedDate: Date?
    var vocab: Vocab
    
    init(vocab: Vocab) {
        self.difficultyParameter = Difficulty(amount: 0)
        self.vocab = vocab
    }
    
    init(vocab: Vocab, difficultyParameter: Difficulty) {
        self.difficultyParameter = Difficulty(amount: 0)
        self.vocab = vocab
    }
    
}

struct Difficulty: Codable, Hashable {
    var amount: Int
}

extension RevisionVocab: Codable {}

extension RevisionVocab: Hashable {}
