//
//  LessonQuizViewModelFromLesson.swift
//  LingoClash
//
//  Created by Sherwin Poh on 20/3/22.
//

import Foundation

class LessonQuizViewModelFromLesson: LessonQuizViewModel {
    private let lesson: Lesson
    let questionGenerator = QuestionsGenerator()
    let starsBenchmarks = [1, 9, 10]
    let initialLives = 1

    var questionSequence: QuestionSequence
    var questionsLoaded = [Question]()
    var questionsStatus = [QuestionStatus]()
    var currQuestionIndex = 0

    var starPositions: [Float] {
        starsBenchmarks.map { Float($0) / Float(maxCorrectQuestions) }
    }
    var progress: Dynamic<Float> = Dynamic(.zero)
    var questionViewModel: Dynamic<QuestionViewModel?> = Dynamic(nil)
    var quizStatus: Dynamic<QuizStatus> = Dynamic(QuizStatus.incomplete)
    var livesLeft: Dynamic<Int>
    var quizOutcomeViewModel: LessonQuizOutcomeViewModel?
    var maxCorrectQuestions: Int {
        starsBenchmarks.last ?? 0
    }

    var quizScore: Int {
        questionsStatus.filter { $0 == .correct }.count
    }

    /// Generates questions from lesson's vocabs, initialises fields
    init(lesson: Lesson) {
        assert(lesson.vocabs.count > 0)
        self.lesson = lesson
        self.livesLeft = Dynamic(initialLives)

        // Generate questions
        let scope = Set(lesson.vocabs)
        let questionGeneratorSettings = QuestionGeneratorSettings(scope: scope, compulsoryTestingScope: scope)
        do {
            self.questionSequence = try self.questionGenerator.generateQuestions(settings: questionGeneratorSettings)
        } catch {
            fatalError("Unable to generate questions")
        }

        loadNextQuestion()
    }

    func loadNextQuestion() {
        guard let currQuestion = self.questionSequence.next() as? Question else {
            fatalError("Unable to load question")
        }
        self.questionsLoaded.append(currQuestion)
        self.questionsStatus.append(.incomplete)
        self.questionViewModel.value = QuestionViewModelFromQuestion(question: currQuestion)
    }

    func questionDidComplete(isCorrect: Bool) {
        if isCorrect {
            self.questionsStatus[currQuestionIndex] = .correct
            self.progress.value += 1 / Float(self.maxCorrectQuestions)
        } else {
            self.questionsStatus[currQuestionIndex] = .wrong
            self.livesLeft.value -= 1
        }

        currQuestionIndex += 1
        guard !isQuizComplete() else {
            self.quizDidComplete()
            return
        }

        loadNextQuestion()
    }

    private func quizDidComplete() {
        assert(!questionsStatus.contains(where: { $0 == .incomplete }))

        let minStarsBenchMark = starsBenchmarks[0]
        let starsObtained = getStarsObtained(score: quizScore)
        let vocabsTested = Set(lesson.vocabs)
        let didPass = quizScore >= minStarsBenchMark
        let quizResult = LessonQuizResult(starsObtained: starsObtained, didPass: didPass,
                                          vocabsTested: vocabsTested, lessonName: lesson.name)
        quizOutcomeViewModel = LessonQuizOutcomeViewModelFromQuizResult(quizResult: quizResult)
        if didPass {
            // TODO: update stars currency for user, update lesson for the stars
            quizStatus.value = QuizStatus.passed
            NotificationCenter.default.post(name: .lessonQuizPassed, object: nil, userInfo: ["stars": starsObtained])
        } else {
            quizStatus.value = QuizStatus.failed
        }

        var updatedLesson = lesson
        updatedLesson.completeQuiz(result: quizResult)
        LessonManager().completeLesson(updatedLesson)
    }

    private func isQuizComplete() -> Bool {
        let highestStarBenchmark = maxCorrectQuestions
        let hasAttainedMaximumStars = quizScore >= highestStarBenchmark
        let haveNoMoreLivesLeft = self.livesLeft.value <= 0
        return hasAttainedMaximumStars || haveNoMoreLivesLeft
    }

    private func getStarsObtained(score: Int) -> Int {
        starsBenchmarks.firstIndex(where: { $0 > score }) ?? starsBenchmarks.count
    }

}
