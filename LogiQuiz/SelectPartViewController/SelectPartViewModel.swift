//
//  SelectPartViewModel.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/09/14.
//

final class SelectPartViewModel {

    private let quizService: ReviewQuizService

    init(quizService: ReviewQuizService = ReviewQuizService()) {
        self.quizService = quizService
    }

    func shouldPresentAlertForEmptyQuizzes() -> Bool {
        return quizService.fetchWrongQuizzes().isEmpty
    }

    func wrongQuizIds() -> [String] {
        return quizService.fetchWrongQuizzes().map { $0.quizid }
    }

    func fetchQuiz(from quizId: String) -> Quiz? {
            return quizService.fetchQuiz(from: quizId)
    }
}
