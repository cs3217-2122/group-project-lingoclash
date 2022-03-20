//
//  QuestionViewModelFromQuestion.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

class QuestionViewModelFromQuestion: QuestionViewModel {
    var questionLayoutViewModel: Dynamic<QuestionLayoutViewModel>?
    init(question: Question){
        switch question {
        case let simpleOptionQuestion as SimpleOptionQuestion:
            self.questionLayoutViewModel = Dynamic(SimpleOptionQuestionLayoutViewModel(question: simpleOptionQuestion))
        case let twoDisjointSetOptionQuestion as TwoDisjointSetOptionQuestion:
            self.questionLayoutViewModel = Dynamic(TwoDisjointSetOptionQuestionLayoutViewModel(question: twoDisjointSetOptionQuestion))
        default:
            assert(false, "Question Format not found")
        }
    }
}
