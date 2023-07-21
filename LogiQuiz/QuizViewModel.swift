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

    private var quizzes: [Quiz] = []
    var currentQuizIndex = 0
    private var correctCount = 0
    static var selectLevel = 0

    var eventHandler: ((Event) -> Void)?

    func loadCSV() {
        guard let filePath = Bundle.main.path(forResource: "Quiz\(QuizViewModel.selectLevel)", ofType: "csv") else {
            eventHandler?(.errorOccurred("Failed to find the CSV file"))
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
                    let correctIndex = (Int(components[1]) ?? 1) - 1 //選択肢のインデックスは1からはじまる
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

//    func inverval() {
//        judgeImageView.isHidden = false
//        answerButton1.isEnabled = false
//        answerButton2.isEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.judgeImageView.isHidden = true
//            self.answerButton1.isEnabled = true
//            self.answerButton2.isEnabled = true
//            self.nextQuiz()
//        }
//    }
}
