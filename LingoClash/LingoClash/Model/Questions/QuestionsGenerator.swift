//
//  QuestionGenerator.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Darwin

class QuestionsGenerator {
    static let questionConstructors: [QuestionContructor] = [DefinitionOptionQuestionConstructor()]
    func generateQuestions(scope: [Vocab], settings: QuestionGeneratorSettings) -> [Question] {
        /*
         1. Get number of questions to construct per constructor randomly
         2. Generate questions for all questiontypes, provide random vocabs from the list of vocabs
         3. Return list of Questions
         */
        let constructors = QuestionsGenerator.questionConstructors
        let constructorsCount = distributeQuestionCount(numberOfQuestions: settings.numberOfQuestions, probabilities: settings.questionConstructorsProbabilities)
        var questions = [Question]()
        for i in 0..<constructors.count {
            let constructor = constructors[i]
            let constructorCount = constructorsCount[i]
            let vocabs = getRandomVocabs(from: scope, count: constructorCount)
            let question = constructor.constructQuestion(with: vocabs)
            if let question = question {
                questions.append(question)
            }
        }
        
        return questions
    }
    
    private func getRandomVocabs(from vocabs: [Vocab], count: Int) -> [Vocab] {
        guard count <= vocabs.count else {
            return []
        }
        return vocabs.getRandomElements(randomPick: count)
    }
    
    private func distributeQuestionCount(numberOfQuestions: Int, probabilities: [Double]?) -> [Int] {
        var constructorsCount = [Int](repeating: 0, count: QuestionsGenerator.questionConstructors.count)

        var constructorsProbabilities = [Double](repeating: 1 / Double(QuestionsGenerator.questionConstructors.count), count: QuestionsGenerator.questionConstructors.count)
        if let probabilities = probabilities, probabilities.count == QuestionsGenerator.questionConstructors.count {
            constructorsProbabilities = probabilities
        }
        
        for _ in 0..<numberOfQuestions {
            let randomConstructorIndex = randomNumber(probabilities: constructorsProbabilities)
            constructorsCount[randomConstructorIndex] += 1
        }
        return constructorsCount
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

struct QuestionGeneratorSettings {
    let numberOfQuestions: Int
    let questionConstructorsProbabilities: [Double]?
}
