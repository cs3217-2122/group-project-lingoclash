//
//  QuestionSequenceState.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

import Algorithms
/// Encapsulates the logic of providing the scope of questions to be generated
struct QuestionScopeFactory {
    var compulsoryScope: [BookVocab]
    var scope: Set<BookVocab>
    
    mutating func getScope(for questionConstructor: QuestionContructor) -> (tested: Set<BookVocab>, others: Set<BookVocab>) {
        let testedVocabs = getTestedVocabs(count: questionConstructor.vocabsTestedCount)
        let otherVocabs = getOtherVocabs(count: questionConstructor.otherVocabsCount, notIn: testedVocabs)
        return (tested: testedVocabs, others: otherVocabs)
    }
    
    private func getOtherVocabs(count: Int, notIn excludeVocabs: Set<BookVocab> = Set()) -> Set<BookVocab> {
        // get vocabs randomly from scope not in excludedVocabs
        guard count >= 0 else {
            return Set()
        }
        let vocabs = scope.subtracting(excludeVocabs)
        return Set(vocabs.randomSample(count: count))
    }
    
    private mutating func getTestedVocabs(count: Int) -> Set<BookVocab> {
        // get and pop from compulsory scope, rest get randomly from scope
        guard !compulsoryScope.isEmpty else {
            return getOtherVocabs(count: count)
        }
        // Pops from compulsory scope, returns, if compulsory scope is empty,
        let countFromCompulsory = min(count, compulsoryScope.count)
        let leftover = count - countFromCompulsory
        let compulsoryVocabs = Set(compulsoryScope.suffix(countFromCompulsory))
        compulsoryScope.removeLast(countFromCompulsory)
        if leftover != 0 {
            let otherVocabs = getOtherVocabs(count: leftover, notIn: compulsoryVocabs)
            return compulsoryVocabs.union(otherVocabs)
        } else {
            return compulsoryVocabs
        }
    }
}
