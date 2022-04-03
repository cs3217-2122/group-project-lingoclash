//
//  QuestionGenerator.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Darwin

class QuestionsGenerator {
    private static let questionConstructors: [QuestionContructor] = [DefinitionOptionQuestionConstructor()]
    
    func generateQuestions(settings: QuestionGeneratorSettings) throws -> QuestionSequence {
        /*
         Functionality should create a question sequence that follows the settings provided
         Create questions of random types that test random vocabs that are within the scope.
         If compulsoryTestScope is provided, need to generate questions that test the vocabs in the CTS.
         Once CTS is empty, able to generate questions that test random vocabs within the scope.
         Generate till question upper limit if any is reached
         */
        let questionConstructorRandomFactory = try createQuestionContructorRandomFactory(questionProbabilities: settings.questionProbabilities,
                                                                                         scopeSize: settings.scope.count)
        let questionScopeFactory = createQuestionScopeFactory(compulsoryScope: settings.compulsoryTestingScope, scope: settings.scope)
        return QuestionSequence(scopeFactory: questionScopeFactory, constructorFactory: questionConstructorRandomFactory)
    }
    
    private func createQuestionScopeFactory(compulsoryScope: Set<Vocab>?, scope: Set<Vocab>) -> QuestionScopeFactory {
        if let compulsoryScope = compulsoryScope {
            return QuestionScopeFactory(compulsoryScope: Array(compulsoryScope), scope: scope)
        } else {
            return QuestionScopeFactory(compulsoryScope: [], scope: scope)
        }
    }
    
    private func createQuestionContructorRandomFactory(questionProbabilities: Dictionary<QuestionType, Double>?, scopeSize: Int) throws -> QuestionConstructorRandomFactory {
        var constructors = [QuestionContructor]()
        var probabilities = [Double]()
        if let questionProbabilities = questionProbabilities {
            for (questionType, probability) in questionProbabilities {
                guard let constructor = getQuestionConstructor(for: questionType),
                      isConstructorViable(constructor, scopeSize: scopeSize) else {
                          continue
                      }
                constructors.append(constructor)
                probabilities.append(probability)
            }
            return QuestionConstructorRandomFactory(constructors: constructors, probabilities: probabilities)
        } else {
            constructors = QuestionsGenerator.questionConstructors.filter { isConstructorViable($0, scopeSize: scopeSize) }
            probabilities = getUniformDistribution(itemCount: constructors.count)
        }
        guard !constructors.isEmpty else {
            throw QuestionGenerationError.insufficientVocabsToGenerateAnyQuestions
        }
        return QuestionConstructorRandomFactory(constructors: constructors, probabilities: probabilities)
        
    }
    
    private func isConstructorViable(_ constructor: QuestionContructor, scopeSize: Int) -> Bool {
        return constructor.otherVocabsCount + constructor.vocabsTestedCount <= scopeSize
    }
    
    private func getUniformDistribution(itemCount: Int) -> [Double] {
        guard itemCount > 0 else {
            return []
        }
        let probability = 1 / Double(itemCount)
        return [Double](repeating: probability, count: itemCount)
    }
    
    private func getQuestionConstructor(for questionType: QuestionType) -> QuestionContructor? {
        switch questionType {
        case .definitionOption:
            return QuestionsGenerator.questionConstructors.first(where: { $0 is DefinitionOptionQuestionConstructor })
        case .matchVocabToDefinitionOption:
            // TODO: Create a constructor for this
            return nil
        }
    }
}

struct QuestionGeneratorSettings {
    // fixed number of questions to generate, if nil, unlimited
    let numberOfQuestions: Int?
    // probability of questions types to generate, if nil, uniformly distributed
    let questionProbabilities: Dictionary<QuestionType, Double>?
    // scope of vocab that need to be tested at least once, needs to be subset of scope
    // TODO: implement subset check
    let compulsoryTestingScope: Set<Vocab>?
    // scope of vocab to generate questions from
    let scope: Set<Vocab>
    
    init(scope: Set<Vocab>, compulsoryTestingScope: Set<Vocab>? = nil, questionProbalities: Dictionary<QuestionType, Double>? = nil, numberOfQuestions: Int? = nil) {
        self.numberOfQuestions = numberOfQuestions
        self.questionProbabilities = questionProbalities
        self.compulsoryTestingScope = compulsoryTestingScope
        self.scope = scope
    }
}
