//
//  simplyOptionQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

class SimpleOptionQuestionLayoutViewModel: QuestionLayoutViewModel {
    let question: SimpleOptionQuestion
    let context: String
    let options: [String]
    let answer: String
    let questionStatus: Dynamic<QuestionStatus> = Dynamic(.incomplete)

    init(question: SimpleOptionQuestion) {
        self.question = question
        self.context = question.context
        self.options = question.options
        self.answer = question.answer
    }
    
    func didSelectOption(at index: Int) {
        let optionSelected = self.options[index]
        let isCorrect = self.question.isCorrect(response: optionSelected)
        questionStatus.value = isCorrect ? .correct : .wrong
    }
}
