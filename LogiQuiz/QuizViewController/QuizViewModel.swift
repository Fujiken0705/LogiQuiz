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

    private var quizzes: [Quiz] = []
    var wrongQuizzes: Set<String> = []
    var currentQuizIndex = 0
    var correctCount = 0

    var isChecked: Bool = false

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
            if let specificQuizIds = self.specificQuizIds {
                quizzes += try CsvLoader.loadCSV(mode: .review, specificQuizIds: specificQuizIds)
            } else {
                quizzes += try CsvLoader.loadCSV(mode: .normal(part: selectPart))
            }
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
        isChecked = false
        let isWrong = wrongQuizzes.contains(quiz.id)
        eventHandler?(.updateUI(quiz, isWrong: isWrong))
    }


    func currentQuiz() -> Quiz? {
        guard currentQuizIndex < quizzes.count else { return nil }
        return quizzes[currentQuizIndex]
    }

    func toggleWrongQuizStatusForIncorrectAnswer() {
        isChecked = true
        if let quiz = currentQuiz() {
            // ここでUIの更新をトリガーする
            eventHandler?(.updateUI(quiz, isWrong: true))
            databaseService.saveWrongQuiz(quizId: quiz.id)
        }

        // 0.5秒後にチェックを外す
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isChecked = false
            if let quiz = self?.currentQuiz() {
                self?.eventHandler?(.updateUI(quiz, isWrong: false))
            }
        }
    }

    func answerSelected(at index: Int) -> Bool {
        guard let quiz = currentQuiz() else { return false }
        let isCorrect = quiz.correctIndex == index

        if !isCorrect {
            isChecked = true
            toggleWrongQuizStatusForIncorrectAnswer()
        } else {
            correctCount += 1
        }

        isCorrect ? Vibration.playcorrect() : Vibration.playincorrect()

        // 0.5秒後に次の問題に進む
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.currentQuizIndex += 1
            if self?.currentQuizIndex ?? 0 < self?.quizzes.count ?? 0 {
                self?.fetchCurrentQuizAndUpdateUI()
            } else {
                self?.eventHandler?(.moveToResultScreen)
            }
        }
        return isCorrect
    }

    func removeWrongQuiz(quizId: String) {
            databaseService.removeWrongQuiz(quizId: quizId)
    }
}
