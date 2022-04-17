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
    
    // TODO: add the date after PR has been merged
//    let last_attempted_date: Date
    let vocab_id: Int
}

extension RevisionVocabData: Record {}
