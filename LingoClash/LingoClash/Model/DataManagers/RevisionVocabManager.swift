//
//  RevisionVocabManager.swift
//  LingoClash
//
//  Created by kevin chua on 15/4/22.
//

import PromiseKit

class RevisionVocabManager: DataManager<RevisionVocabData> {
    
    init() {
        super.init(resource: "revision_vocabs")
    }
    
}
