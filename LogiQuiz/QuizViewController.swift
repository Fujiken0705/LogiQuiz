//
//  QuizViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit
import AudioToolbox
import AVFoundation

class QuizViewController: UIViewController {

    @IBOutlet private weak var quizNumberLabel: UILabel!
    @IBOutlet private weak var quizTextView: UITextView!
    @IBOutlet private weak var answerButton1: UIButton!
    @IBOutlet private weak var answerButton2: UIButton!
    @IBOutlet private weak var judgeImageView: UIImageView!

    private let viewModel = QuizViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadCSV()
        updateUI()

        viewModel.eventHandler = { event in
            switch event {
            case .errorOccurred(let message):
                print(message)
            }
        }
    }

    private func updateUI() {
        guard let quiz = viewModel.currentQuiz() else { return }
        quizNumberLabel.text = "問題 \(viewModel.currentQuizIndex + 1)"
        quizTextView.text = quiz.title
        answerButton1.setTitle(quiz.selections[0], for: .normal)
        answerButton2.setTitle(quiz.selections[1], for: .normal)
    }

    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        let isCorrect = viewModel.checkAnswer(sender.tag - 1)
        judgeImageView.image = isCorrect ? Images.correct : Images.incorrect
        playSound(isCorrect: isCorrect)
        if viewModel.nextQuiz() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateUI()
            }
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }

    private func playSound(isCorrect: Bool) {
        Feedback()
        Player.play(soundURL: isCorrect ? SoundURL.correct : SoundURL.incorrect)
    }
}
