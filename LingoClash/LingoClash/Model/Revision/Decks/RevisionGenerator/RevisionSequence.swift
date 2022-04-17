//
//  RevisionSequence.swift
//  LingoClash
//
//  Created by kevin chua on 2/4/22.
//

/// Note that not all RevisionVocabs need to be tested. They are sorted by a priority queue and only up to a certain
/// day difference they will be tested
struct RevisionSequence: QuerySequence {
    
    typealias criteriaType = (RevisionQuery) -> Bool
    let criteria: criteriaType
    
    var questionsLeft: Int?
    
    // Basically you have a priority queue of RevisionQueries
    // and the next function will reduce the number by 1
    var revisionPq: Heap<RevisionQuery>

    init(revisionQueryArr: [RevisionQuery], criteria: @escaping criteriaType) {
        self.criteria = criteria
        // convert into heap
        self.revisionPq = Heap<RevisionQuery>(sort: {
            (rq1: RevisionQuery, rq2: RevisionQuery) -> Bool in
            rq1.magnitude < rq2.magnitude
        })
        self.questionsLeft = revisionQueryArr.count
        
        // initialise pq
        for rq in revisionQueryArr {
            self.insert(rq)
        }
    }
    
    init(deck: Deck, criteria: @escaping criteriaType) {
        self.init(revisionQueryArr: deck.vocabs, criteria: criteria)
    }
    
    mutating func insert(_ rq: RevisionQuery) {
        // only insert things smaller than a set magnitude
        print(rq.magnitude)
        guard criteria(rq) else {
            Logger.info("Revision Query \(rq) discarded from queue")
            return
        }
        
        self.revisionPq.insert(rq)
    }
    
    mutating func remove(_ rq: RevisionQuery) {
        self.revisionPq.remove(node: rq)
    }
    
    // pops off from the queue and returns the value
    mutating func next() -> Query? {
        let nextRevision = self.revisionPq.remove()
        self.questionsLeft = revisionPq.count
        
        return nextRevision
    }
    
    func count() -> Int {
        revisionPq.count
    }
}

extension RevisionSequence: CustomStringConvertible {
    var description: String {
        revisionPq.description
    }
}
