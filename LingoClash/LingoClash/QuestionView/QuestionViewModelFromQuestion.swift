//
//  QuestionViewModelFromQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

class QuestionViewModelFromQuestion: QuestionViewModel {
    var questionLayoutViewModel: QuestionLayoutViewModel?
    init(question: Question) {
        switch question {
        case let simpleOptionQuestion as SimpleOptionQuestion:
            self.questionLayoutViewModel = SimpleOptionQuestionLayoutViewModel(question: simpleOptionQuestion)
        case let twoDisjointSetOptionQuestion as TwoDisjointSetOptionQuestion:
            self.questionLayoutViewModel = TwoDisjointSetOptionQuestionLayoutViewModel(
                question: twoDisjointSetOptionQuestion)
        default:
            assert(false, "Question Format not found")
        }
    }
}
