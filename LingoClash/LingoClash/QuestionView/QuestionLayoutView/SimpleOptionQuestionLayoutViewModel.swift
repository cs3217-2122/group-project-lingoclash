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
    let questionStatus: Dynamic<QuestionStatus> = Dynamic(.incomplete)
    var optionSelectedIndex: Int?
    var answerIndex: Int

    init(question: SimpleOptionQuestion) {
        self.question = question
        self.context = question.context
        self.options = question.options
        guard let answerIndex = question.options.firstIndex(where: { question.isCorrect(response: $0) }) else {
            self.answerIndex = 0
            fatalError("No options are the correct.")
        }
        self.answerIndex = answerIndex
    }

    func didSelectOption(at index: Int) {
        guard optionSelectedIndex == nil else {
            return
        }
        let optionSelected = self.options[index]
        let isCorrect = self.question.isCorrect(response: optionSelected)
        optionSelectedIndex = index
        questionStatus.value = isCorrect ? .correct : .wrong
    }
}
