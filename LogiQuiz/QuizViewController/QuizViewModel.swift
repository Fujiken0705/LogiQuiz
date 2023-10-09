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

    enum CheckBoxState {
        case unchecked
        case checkedByUser
        case checkedBySystem

        // ischeckedを変数
        //computedpropaty
    }

    private var quizzes: [Quiz] = []
    var wrongQuizzes: Set<String> = []
    var currentQuizIndex = 0
    var correctCount = 0

    var checkBoxState: CheckBoxState = .unchecked

    var selectPart: Int
    var specificQuizIds: [String]?
    private var databaseService: QuizDatabaseService

    var eventHandler: ((Event) -> Void)?

    init(selectPart: Int, specificQuizIds: [String]? = nil) {
        self.selectPart = selectPart
        self.specificQuizIds = specificQuizIds
        self.databaseService = QuizDatabaseService()
    }

    func loadCSV() {
        do {
            quizzes += try CsvLoader.loadCSV(part: selectPart, specificQuizIds: specificQuizIds)
        } catch CsvLoaderError.fileNotFound {
            eventHandler?(.errorOccurred("Failed to find the CSV file for Quiz\(selectPart)"))
        } catch {
            eventHandler?(.errorOccurred("Failed to read the CSV file for part \(selectPart): \(error)"))
        }
        fetchCurrentQuizAndUpdateUI()
    }

    //テストを書こう,チェック機能の修正

    private func fetchCurrentQuizAndUpdateUI() {
        guard let quiz = currentQuiz() else { return }
        let isWrong = wrongQuizzes.contains(quiz.id)
        eventHandler?(.updateUI(quiz, isWrong: isWrong))
    }

    func currentQuiz() -> Quiz? {
        guard currentQuizIndex < quizzes.count else { return nil }
        return quizzes[currentQuizIndex]
    }

    func toggleWrongQuizStatus(byUser: Bool) {
            switch checkBoxState {
            case .unchecked:
                checkBoxState = byUser ? .checkedByUser : .checkedBySystem
            case .checkedByUser, .checkedBySystem:
                checkBoxState = .unchecked
            }

            //checkboxの状態に応じて処理
            if let quiz = currentQuiz() {
                switch checkBoxState {
                case .unchecked:
                    databaseService.removeWrongQuiz(quizId: quiz.id)
                case .checkedByUser, .checkedBySystem:
                    databaseService.saveWrongQuiz(quizId: quiz.id)
                }
            }

            fetchCurrentQuizAndUpdateUI()
    }

    func answerSelected(at index: Int) -> Bool {
        guard let quiz = currentQuiz() else { return false }

        let isCorrect = quiz.correctIndex == index
        if isCorrect {
            correctCount += 1
        } else {
            wrongQuizzes.insert(quiz.id)
            databaseService.saveWrongQuiz(quizId: quiz.id)
            toggleWrongQuizStatus(byUser: false)
        }

        isCorrect ? Vibration.playcorrect() : Vibration.playincorrect()

        // 次の問題が存在するかを確認して、存在する場合はインデックスを更新
        currentQuizIndex += 1
        if currentQuizIndex < quizzes.count {
            fetchCurrentQuizAndUpdateUI()
        } else {
            eventHandler?(.moveToResultScreen) // 全ての問題が終了した際、結果表示画面に遷移するイベントをトリガー
        }

        return isCorrect
    }
}
