//
//  QuestionSequenceState.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

import Algorithms
/// Encapsulates the logic of providing the scope of questions to be generated
struct QuestionScopeFactory {
    var compulsoryScope: [Vocab]
    var scope: Set<Vocab>

    mutating func getScope(for questionConstructor: QuestionContructor) -> (tested: Set<Vocab>, others: Set<Vocab>) {
        let testedVocabs = getTestedVocabs(count: questionConstructor.vocabsTestedCount)
        let otherVocabs = getOtherVocabs(count: questionConstructor.otherVocabsCount, notIn: testedVocabs)
        return (tested: testedVocabs, others: otherVocabs)
    }

    private func getOtherVocabs(
        count: Int, notIn excludeVocabs: Set<Vocab> = Set()) -> Set<Vocab> {
        // get vocabs randomly from scope not in excludedVocabs
        guard count >= 0 else {
            return Set()
        }
        let vocabs = scope.subtracting(excludeVocabs)
        return Set(vocabs.randomSample(count: count))
    }

    private mutating func getTestedVocabs(count: Int) -> Set<Vocab> {
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
