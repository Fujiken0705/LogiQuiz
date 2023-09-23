//
//  SelectPartViewModel.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/09/14.
//

import RealmSwift
import Foundation

final class SelectPartViewModel {

    // Outputs
    var title: String = "パートを選択"

    // Dependencies
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func fetchWrongQuizzes() -> [WrongQuiz] {
        return Array(realm.objects(WrongQuiz.self))
    }

    func fetchQuiz(from quizId: String) -> Quiz? {
        print("Fetching quiz for ID: \(quizId)")

        let parts = quizId.split(separator: "q")
        guard let part = parts.first, let index = Int(parts.last ?? "") else {
            print("Failed to split quizId: \(quizId) into part and index")
            return nil
        }

        let resourceName = "Quiz\(part.dropFirst())"
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "csv") else {
            print("Failed to find CSV for resource name: \(resourceName)")
            return nil
        }

        do {
            let csvData = try String(contentsOfFile: filePath)
            let csvLines = csvData.components(separatedBy: .newlines)
            guard index <= csvLines.count else {
                print("Index out of range for quizId: \(quizId)")
                return nil
            }
            let line = csvLines[index - 1]
            let components = line.components(separatedBy: ",")
            guard components.count >= 3 else {
                print("Insufficient data for quizId: \(quizId)")
                return nil
            }
            let title = components[0]
            let correctIndex = (Int(components[1]) ?? 1) - 1
            let selections = Array(components[2...])
            return Quiz(id: quizId, title: title, selections: selections, correctIndex: correctIndex)
        } catch {
            print("Error reading CSV for quiz id: \(quizId), error: \(error)")
            return nil
        }
    }

    func shouldPresentAlertForEmptyQuizzes() -> Bool {
        return fetchWrongQuizzes().isEmpty
    }

    func wrongQuizIds() -> [String] {
        return fetchWrongQuizzes().map { $0.quizid }
    }

}

//できればServiceクラスを作って責務分けを行った方が良い？？
