//
//  RevisionQuery.swift
//  LingoClash
//
//  Created by kevin chua on 11/4/22.
//

import Foundation

// A wrapper for a Query object
struct RevisionQuery: Query {
    var revVocab: RevisionVocab
    
    init(vocab: RevisionVocab) {
        self.revVocab = vocab
    }
    
    init(vocab: RevisionVocab, difficulty: Difficulty, lastAttemptedDate: Date?) {
        self.revVocab = vocab

        self.revVocab.difficultyParameter = difficulty
        self.revVocab.lastAttemptedDate = lastAttemptedDate
    }
    
    var context: String {
        get {
            revVocab.vocab.word
        }
    }
    
    var answerToString: String {
        get {
            revVocab.vocab.definition
        }
    }
    
    var magnitude: Double {
        get {
            revVocab.magnitude
        }
    }
}

extension RevisionQuery: Equatable {}

extension RevisionQuery: Codable {}
