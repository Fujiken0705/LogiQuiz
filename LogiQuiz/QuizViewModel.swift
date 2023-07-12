//
//  QuizViewModel.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/07/12.
//

import UIKit

final class QuizViewModel {
    var quizzes: [Quiz] = []
    var currentQuizIndex = 0
    var correctCount = 0

    func loadCSV() {
        guard let filePath = Bundle.main.path(forResource: "quiz", ofType: "csv") else {
            print("Failed to find the CSV file.")
            return
        }

        do {
            let csvData = try String(contentsOfFile: filePath)
            let csvLines = csvData.components(separatedBy: .newlines)

            for line in csvLines {
                let components = line.components(separatedBy: ",")
                if components.count >= 3 {
                    let title = components[0]
                    let correctIndex = Int(components[1]) ?? 0
                    let selections = Array(components[2...])
                    let quiz = Quiz(title: title, selections: selections, correctIndex: correctIndex)
                    quizzes.append(quiz)
                }
            }
        } catch {
            print("Failed to read the CSV file: \(error)")
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
