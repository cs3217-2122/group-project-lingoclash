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
    let vocab_id: Int
}

extension RevisionVocabData: Record {}
