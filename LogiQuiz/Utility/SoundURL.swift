//
//  SoundURL.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/07/20.
//

import Foundation

enum SoundURL {
    static let correct = Bundle.main.url(forResource: "correct", withExtension: "mp3")!
    static let incorrect = Bundle.main.url(forResource: "incorrect", withExtension: "mp3")!
}
