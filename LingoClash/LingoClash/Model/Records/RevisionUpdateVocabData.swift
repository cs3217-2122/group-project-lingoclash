//
//  RevisionUpdateVocabData.swift
//  LingoClash
//
//  Created by kevin chua on 17/4/22.
//

import Foundation

struct RevisionUpdateVocabData {
    let id: Identifier
    let difficulty: Int
    
    let last_attempted_date: Date
    let vocab_id: Identifier
}

extension RevisionUpdateVocabData: Record {}
