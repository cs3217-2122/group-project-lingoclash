//
//  DeckData.swift
//  LingoClash
//
//  Created by kevin chua on 15/4/22.
//

struct DeckData {
    var id: Identifier
    let name: String
    let profile_id: Identifier
    let revision_vocab_id: [Identifier]
}

extension DeckData: Record {}
extension DeckData: Hashable {}
