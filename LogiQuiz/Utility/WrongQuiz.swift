//
//  WrongQuiz.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/08/25.
//

import Foundation
import RealmSwift

class WrongQuiz: Object {
    @objc dynamic var quizid: String = ""
    @objc dynamic var wrongdate: Date = Date()
}
