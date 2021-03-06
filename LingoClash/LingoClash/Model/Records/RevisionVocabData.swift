//
//  RevisionVocabData.swift
//  LingoClash
//
//  Created by kevin chua on 15/4/22.
//

import Foundation

struct RevisionVocabData {
    let id: Identifier
    let difficulty: Int
    
    let last_attempted_date: Date
    let vocab_id: Identifier
    let deck_id: Identifier
}

extension RevisionVocabData: Record {}
