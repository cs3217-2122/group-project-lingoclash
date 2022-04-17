//
//  RevisionQuery.swift
//  LingoClash
//
//  Created by kevin chua on 11/4/22.
//

import Foundation

struct RevisionQuery: Query {
    var id: Identifier
    // Starts from 0
    var revVocab: RevisionVocab
    
    
    var difficultyParameter: Difficulty
    var lastAttemptedDate: Date?
    
    let context: String
    var answerToString: String
    
    init(vocab: RevisionVocab, context: String, answer: String, id: Identifier) {
        self.revVocab = vocab
        self.context = context
        self.answerToString = answer
        
        self.difficultyParameter = Difficulty(amount: 0)
        self.id = id
    }
    
    init(vocab: RevisionVocab, context: String, answer: String, difficulty: Difficulty, lastAttemptedDate: Date?, id: Identifier) {
        self.revVocab = vocab
        self.context = context
        self.answerToString = answer
        
        self.difficultyParameter = difficulty
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

extension RevisionQuery: Equatable {}

extension RevisionQuery: Codable {}
