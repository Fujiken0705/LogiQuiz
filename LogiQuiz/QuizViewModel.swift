//
//  QuizViewModel.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/07/12.
//

import UIKit
import AVFAudio

final class QuizViewModel {
    enum Event {
        case errorOccurred(String)
    }

    private var quizzes: [Quiz] = []//test行けそう
    var currentQuizIndex = 0
    var correctCount = 0
    private var selectPart: Int

    init(selectPart: Int) {
        self.selectPart = selectPart
    }

    var eventHandler: ((Event) -> Void)?

    func loadCSV() {
        guard let filePath = Bundle.main.path(forResource: "Quiz\(selectPart)", ofType: "csv") else {
            eventHandler?(.errorOccurred("Failed to find the CSV file"))
                print("Failed to find the CSV file.")
                return
        }

        do {
            let csvData = try String(contentsOfFile: filePath)
            let csvLines = csvData.components(separatedBy: .newlines)

            for (index, line) in csvLines.enumerated() {
                let components = line.components(separatedBy: ",")
                if components.count >= 3 {
                    let title = components[0]
                    let correctIndex = (Int(components[1]) ?? 1) - 1 //選択肢のインデックスは1からはじまる
                    let selections = Array(components[2...])
                    let id = "p\(selectPart)q\(index + 1)"
                    let quiz = Quiz(id: id, title: title, selections: selections, correctIndex: correctIndex)
                    quizzes.append(quiz)
                }
            }
        } catch {
            eventHandler?(.errorOccurred("Failed to read the CSV file: \(error)"))
        }
    }

    func currentQuiz() -> Quiz? {
        guard currentQuizIndex < quizzes.count else { return nil }
        return quizzes[currentQuizIndex]
    }

    func checkAnswer(_ answerIndex: Int) -> Bool {
        guard let quiz = currentQuiz() else { return false }
                if quiz.correctIndex == answerIndex {
                    correctCount += 1
                    return true
                }
                return false
    }

    func nextQuiz() -> Bool {
        currentQuizIndex += 1
        return currentQuizIndex < quizzes.count
    }

}
