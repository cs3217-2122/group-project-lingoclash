//
//  QuestionConstructorRandomFactory.swift
//  LingoClash
//
//  Created by Sherwin Poh on 22/3/22.
//

struct QuestionConstructorRandomFactory {
    private let constructors: [QuestionContructor]
    private let probabilities: [Double]
    init(constructors: [QuestionContructor], probabilities: [Double]) {
        self.constructors = constructors
        self.probabilities = probabilities
    }
    func getQuestionConstructor() -> QuestionContructor {
        let randomConstructorIndex = randomNumber(probabilities: probabilities)
        return constructors[randomConstructorIndex]
    }

    private func randomNumber(probabilities: [Double]) -> Int {
        let sum = probabilities.reduce(0, +)
            let rnd = Double.random(in: 0.0 ..< sum)
            var accum = 0.0
            for (i, p) in probabilities.enumerated() {
                accum += p
                if rnd < accum {
                    return i
                }
            }
            return (probabilities.count - 1)
    }
}
