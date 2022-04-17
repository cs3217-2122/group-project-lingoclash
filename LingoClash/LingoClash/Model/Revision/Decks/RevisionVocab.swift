//
//  RevisionVocab.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//

import Foundation

struct RevisionVocab {
    var id: Identifier
    var difficultyParameter: Difficulty
    var lastAttemptedDate: Date?
    var vocab: Vocab
    
    init(id: Identifier, vocab: Vocab) {
        self.difficultyParameter = Difficulty(amount: 0)
        self.vocab = vocab
        self.id = id
    }
    
    init(id: Identifier, vocab: Vocab, difficultyParameter: Difficulty) {
        self.difficultyParameter = difficultyParameter
        self.vocab = vocab
        self.id = id
    }
    
    init(id: Identifier, vocab: Vocab, difficultyParameter: Difficulty, lastAttemptedDate: Date) {
        self.difficultyParameter = difficultyParameter
        self.vocab = vocab
        self.lastAttemptedDate = lastAttemptedDate
        self.id = id
    }
    
    // This magnitude is calculated on the fly, because the time difference always changes when Today changes
    var magnitude: Double {
        get {
            let difficultyVal: Double = Double(difficultyParameter.amount)
            let timeDiff: TimeInterval? = lastAttemptedDate?.timeIntervalSinceNow
            let lengthSinceLastDoneVal: Double = abs(timeDiff ?? 0)
            
            // Calculation to get the magnitude of each RevisionQuery
            return difficultyVal + lengthSinceLastDoneVal / 3600
        }
    }
    
    
    
}

struct Difficulty: Codable, Hashable {
    var amount: Int
}

extension RevisionVocab: Codable {}

extension RevisionVocab: Hashable {}
