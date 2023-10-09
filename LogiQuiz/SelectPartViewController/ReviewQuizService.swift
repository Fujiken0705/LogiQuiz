//
//  ReviewQuizService.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/09/23.
//

import RealmSwift
import Foundation

class ReviewQuizService {

    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func fetchWrongQuizzes() -> [WrongQuiz] {
        return Array(realm.objects(WrongQuiz.self))
    }

    func fetchQuiz(from quizId: String) -> Quiz? {
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
}

//DONE Serviceクラスを導入することで、ViewModelがデータ取得や操作の詳細から切り離される→テストが容易に？？
