//
//  Player.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/07/20.
//

import Foundation
import AVFAudio

final class Player {
    static func play(soundURL: URL) {
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            player.play()
        } catch {
            print("error")
        }
    }
}
