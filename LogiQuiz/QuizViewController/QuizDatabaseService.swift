//
//  QuizDatabaseService.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/09/24.
//

import RealmSwift

class QuizDatabaseService {

    // クイズが間違っているかどうかを確認する
    func isQuizWrong(quizId: String) -> Bool {
        guard let realm = try? Realm() else { return false }
        return !realm.objects(WrongQuiz.self).filter("quizid == %@", quizId).isEmpty
    }

    // 間違ったクイズを保存する
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

    // 間違ったクイズを削除する
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
