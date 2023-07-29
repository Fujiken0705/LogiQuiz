//
//  Player.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/07/20.
//

import Foundation
import AVFAudio

final class Player {
    static var player: AVAudioPlayer?
    static func play(soundURL: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
}
