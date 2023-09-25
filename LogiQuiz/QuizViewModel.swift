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
        // selectPartが0の場合でも、specificQuizIdsが指定されている場合は、全てのCSVを読み込む
        let partsToLoad: [Int]
        if selectPart == 0 {
            partsToLoad = [1, 2, 3, 4, 5, 6, 7, 8]
        } else {
            partsToLoad = [selectPart]
        }

        for part in partsToLoad {
            guard let filePath = Bundle.main.path(forResource: "Quiz\(part)", ofType: "csv") else {
                eventHandler?(.errorOccurred("Failed to find the CSV file for Quiz\(part)"))
                continue
            }

            do {
                let csvData = try String(contentsOfFile: filePath)
                let csvLines = csvData.components(separatedBy: .newlines)

                for (index, line) in csvLines.enumerated() {
                    let components = line.components(separatedBy: ",")
                    if components.count >= 3 {
                        let title = components[0]
                        let correctIndex = (Int(components[1]) ?? 1) - 1
                        let selections = Array(components[2...])
                        let id = "p\(part)q\(index + 1)"

                        if let specificIds = specificQuizIds, !specificIds.contains(id) {
                            continue
                        }

                        let quiz = Quiz(id: id, title: title, selections: selections, correctIndex: correctIndex)
                        quizzes.append(quiz)
                    }
                }
            } catch {
                eventHandler?(.errorOccurred("Failed to read the CSV file for part \(part): \(error)"))
            }
        }
        fetchCurrentQuizAndUpdateUI()
    }

    private func fetchCurrentQuizAndUpdateUI() {
        guard let quiz = currentQuiz() else { return }
        let isWrong = wrongQuizzes.contains(quiz.id)
        eventHandler?(.updateUI(quiz, isWrong: isWrong))
    }

    func currentQuiz() -> Quiz? {
        guard currentQuizIndex < quizzes.count else { return nil }
        return quizzes[currentQuizIndex]
    }

    func toggleWrongQuizStatus() {
        guard let quiz = currentQuiz() else { return }
        if wrongQuizzes.contains(quiz.id) {
            wrongQuizzes.remove(quiz.id)
        } else {
            wrongQuizzes.insert(quiz.id)
        }
        fetchCurrentQuizAndUpdateUI()
    }

    func answerSelected(at index: Int) -> Bool {
        guard let quiz = currentQuiz() else { return false }

        let isCorrect = quiz.correctIndex == index
        if isCorrect {
            correctCount += 1
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
