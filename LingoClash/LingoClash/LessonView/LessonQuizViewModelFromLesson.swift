//
//  LessonQuizViewModelFromLesson.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

class LessonQuizViewModelFromLesson: LessonQuizViewModel {
    let lesson: Lesson
    let questionGenerator = QuestionsGenerator()
    let questionsCount = 10
    let starsBenchmarks = [7,9,10]
    var starPositions: [Float] {
        starsBenchmarks.map { Float($0) / Float(questionsCount) }
    }
    let questions: [Question]
    var questionsStatus: [QuestionStatus]
    var currQuestionIndex = 0
    
    var progress: Dynamic<Float>
    var questionViewModel: Dynamic<QuestionViewModel>
    var quizStatus: Dynamic<QuizStatus> = Dynamic(QuizStatus.incomplete)

    /// Generates questions from lesson's vocabs, initialises fields
    init(lesson: Lesson) {
        assert(lesson.vocabs.count > 0)
        self.lesson = lesson
        let settings = QuestionGeneratorSettings(numberOfQuestions: questionsCount,
                                                 questionConstructorsProbabilities: nil)
        self.questions = self.questionGenerator.generateQuestions(scope: lesson.vocabs, settings: settings)
        self.questionsStatus = [QuestionStatus](repeating: .incomplete, count: self.questions.count)
        let currQuestion = self.questions[self.currQuestionIndex]
        self.questionViewModel = Dynamic(QuestionViewModelFromQuestion(question: currQuestion))
        self.progress = Dynamic(0.0)
    }
    
    func questionDidComplete(isCorrect: Bool) {
        if isCorrect {
            self.questionsStatus[currQuestionIndex] = .correct
            self.progress.value += 1 / Float(self.questionsCount)
        } else {
            self.questionsStatus[currQuestionIndex] = .wrong
        }
        currQuestionIndex += 1
        let isQuizIncomplete = currQuestionIndex < self.questions.count
        guard isQuizIncomplete else {
            self.quizDidComplete()
            return
        }
        let currQuestion = self.questions[self.currQuestionIndex]
        self.questionViewModel.value = QuestionViewModelFromQuestion(question: currQuestion)
    }
    
    private func quizDidComplete() {
        guard !questionsStatus.contains(where: { $0 == .incomplete }) else {
            return
        }
        let score = questionsStatus.filter { $0 == .correct }.count
        let didPass = score > starsBenchmarks[0]
        if didPass {
            // TODO: update stars currency for user, update lesson for the stars
            let starsObtained = getStarsObtained(score: score)
            quizStatus.value = QuizStatus.passed
        } else {
            quizStatus.value = QuizStatus.failed
        }
    }
    
    private func getStarsObtained(score: Int) -> Int {
        return starsBenchmarks.firstIndex(where: { $0 > score }) ?? starsBenchmarks.count
    }
    
}
