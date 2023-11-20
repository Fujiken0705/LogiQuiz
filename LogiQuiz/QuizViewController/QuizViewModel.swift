//
//  QuizViewModel.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/07/12.
//

import UIKit

final class QuizViewModel {

    enum Event {
        case errorOccurred(String)
        case updateUI(Quiz, isWrong: Bool)
        case moveToResultScreen
    }

    // クイズの状態を管理するためのStruct
    private struct QuizState {
        var wrongQuizzes: Set<String> = []
        var currentQuizIndex = 0
        var correctCount = 0
        var isChecked: Bool = false
        var quizzes: [Quiz] = []
    }

    private var state = QuizState()
    var selectPart: Int
    var specificQuizIds: [String]?
    private var databaseService: QuizDatabaseService
    var eventHandler: ((Event) -> Void)?

    init(selectPart: Int, specificQuizIds: [String]? = nil) {
        self.selectPart = selectPart
        self.specificQuizIds = specificQuizIds
        self.databaseService = QuizDatabaseService()
    }

    var currentQuizIndex: Int {
        return state.currentQuizIndex
    }

    var correctCount: Int {
        return state.correctCount
    }

    var wrongQuizzes: Set<String> {
        return state.wrongQuizzes
    }

    // CSVファイルを読み込みとエラーハンドリング
    func loadCSV() {
        do {
            state.quizzes = try loadQuizzes()
        } catch CsvLoaderError.fileNotFound {
            eventHandler?(.errorOccurred("Quiz file not found."))
        } catch {
            eventHandler?(.errorOccurred("Error occurred while reading the Quiz file: \(error.localizedDescription)"))
        }
        fetchCurrentQuizAndUpdateUI()
    }

    // 指定されたモードに基づいてクイズをロード（通常モード／復習モード）
    private func loadQuizzes() throws -> [Quiz] {
        if let specificQuizIds = self.specificQuizIds {
            return try CsvLoader.loadCSV(mode: .review, specificQuizIds: specificQuizIds)
        } else {
            return try CsvLoader.loadCSV(mode: .normal(part: selectPart))
        }
    }

    // 現在のクイズに基づいてUIを更新
    private func fetchCurrentQuizAndUpdateUI() {
        guard let quiz = currentQuiz() else { return }
        state.isChecked = false
        let isWrong = state.wrongQuizzes.contains(quiz.id)
        eventHandler?(.updateUI(quiz, isWrong: isWrong))
    }

    // 現在のクイズを取得
    func currentQuiz() -> Quiz? {
        guard state.currentQuizIndex < state.quizzes.count else { return nil }
        return state.quizzes[state.currentQuizIndex]
    }

    // 回答を処理と状態を更新
    func answerSelected(at index: Int) -> Bool {
        guard let quiz = currentQuiz() else { return false }
        let isCorrect = quiz.correctIndex == index

        if isCorrect {
            state.correctCount += 1
            state.wrongQuizzes.remove(quiz.id)
            databaseService.removeWrongQuiz(quizId: quiz.id)
        } else {
            state.wrongQuizzes.insert(quiz.id)
            databaseService.saveWrongQuiz(quizId: quiz.id)
        }
        eventHandler?(.updateUI(quiz, isWrong: !isCorrect))

        isCorrect ? Vibration.playcorrect() : Vibration.playincorrect()

        // 次の問題に進む
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.state.currentQuizIndex += 1
            if self?.state.currentQuizIndex ?? 0 < self?.state.quizzes.count ?? 0 {
                self?.fetchCurrentQuizAndUpdateUI()
            } else {
                self?.eventHandler?(.moveToResultScreen)
            }
        }
        return isCorrect
    }
}
