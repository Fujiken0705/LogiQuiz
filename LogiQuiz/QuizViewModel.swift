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
    var correctCount = 0
    var selectPart: Int
    var specificQuizIds: [String]?

    init(selectPart: Int, specificQuizIds: [String]? = nil) {
        self.selectPart = selectPart
        self.specificQuizIds = specificQuizIds
    }

    var eventHandler: ((Event) -> Void)?

    func loadCSV() {
        // selectPartが0の場合はCSVのロードをスキップ
        if selectPart == 0 {
            print("Skipping CSV loading as selectPart is 0.")
            return
        }

        // 1. 選択されているselectPartをログに出力
        print("Loading CSV for selectPart: \(selectPart)")

        guard let filePath = Bundle.main.path(forResource: "Quiz\(selectPart)", ofType: "csv") else {
            eventHandler?(.errorOccurred("Failed to find the CSV file for Quiz\(selectPart)"))
            print("Failed to find the CSV file for Quiz\(selectPart).")
            return
        }

        // 2. specificQuizIdsの内容をログに出力（もしnilでない場合）
        if let specificIds = specificQuizIds {
            print("Specific Quiz IDs to load: \(specificIds)")
        }

        // 3. 使用しているファイルパスをログに出力
        print("Using file path: \(filePath)")

        do {
            let csvData = try String(contentsOfFile: filePath)
            let csvLines = csvData.components(separatedBy: .newlines)

            for (index, line) in csvLines.enumerated() {
                // 4. 読み込んだ各行の情報をログに出力
                print("Processing line \(index + 1): \(line)")

                let components = line.components(separatedBy: ",")
                if components.count >= 3 {
                    let title = components[0]
                    let correctIndex = (Int(components[1]) ?? 1) - 1
                    let selections = Array(components[2...])
                    let id = "p\(selectPart)q\(index + 1)"

                    if let specificIds = specificQuizIds, !specificIds.contains(id) {
                        // 5. specificQuizIdsに基づいてクイズがスキップされる情報をログに出力
                        print("Skipping quiz ID \(id) based on specificQuizIds")
                        continue
                    }

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
