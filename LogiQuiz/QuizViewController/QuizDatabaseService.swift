//
//  QuizDatabaseService.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/09/24.
//

import RealmSwift

class QuizDatabaseService {

    func isQuizWrong(quizId: String) -> Bool {
        let realm = try! Realm()
        return !realm.objects(WrongQuiz.self).filter("quizid == %@", quizId).isEmpty
    }

    func saveWrongQuiz(quizId: String) {
        let wrongQuiz = WrongQuiz()
        wrongQuiz.quizid = quizId

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(wrongQuiz)
            }
        } catch {
            print("Failed to save wrong quiz: \(error)")
        }
    }

    func removeWrongQuiz(quizId: String) {
        do {
            let realm = try Realm()
            if let wrongQuiz = realm.objects(WrongQuiz.self).filter("quizid == %@", quizId).first {
                try realm.write {
                    realm.delete(wrongQuiz)
                }
            }
        } catch {
            print("Failed to remove wrong quiz: \(error)")
        }
    }
}
