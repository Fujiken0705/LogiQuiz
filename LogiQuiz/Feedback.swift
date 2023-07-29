//
//  Feedback.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/07/20.
//

import AudioToolbox
import UIKit

final class Feedback {
    static func playcorrect() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    static func playincorrect() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
    }
}
