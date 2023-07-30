//
//  QuizViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit
import AudioToolbox

class QuizViewController: UIViewController {

    @IBOutlet private weak var quizNumberLabel: UILabel!
    @IBOutlet private weak var quizTextView: UITextView!
    @IBOutlet private weak var answerButton1: UIButton!
    @IBOutlet private weak var answerButton2: UIButton!
    @IBOutlet private weak var judgeImageView: UIImageView!

    private let viewModel = QuizViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //UIAlertControllerの表示はメインスレッドで行わなければならないのでDispatchQueue.main.asyncを使用。
        viewModel.eventHandler = { [weak self] event in
            switch event {
            case .errorOccurred(let message):
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alertController, animated: true)
                }
            }
        }
        viewModel.loadCSV()
        updateQuizzes()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScoreVC",
           let scoreViewController = segue.destination as? ScoreViewController {
            scoreViewController.correct = viewModel.correctCount
            scoreViewController.questionnum = viewModel.currentQuizIndex
        }
    }

    private func updateQuizzes() {
        guard let quiz = viewModel.currentQuiz() else { return }
        quizNumberLabel.text = "問題 \(viewModel.currentQuizIndex + 1)"
        quizTextView.text = quiz.title
        answerButton1.setTitle(quiz.selections[0], for: .normal)
        answerButton2.setTitle(quiz.selections[1], for: .normal)
    }

    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        let isCorrect = viewModel.checkAnswer(sender.tag - 1)
        self.judgeImageView.isHidden = false
        isCorrect ? Feedback.playcorrect() : Feedback.playincorrect()
        playSound(isCorrect: isCorrect)
        updateCorrectUI(isCorrect: isCorrect)
        if viewModel.nextQuiz() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateQuizzes()
                self.judgeImageView.isHidden = true
            }
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }

    private func playSound(isCorrect: Bool) {
        Player.play(soundURL: isCorrect ? SoundURL.correct : SoundURL.incorrect)
    }

    private func updateCorrectUI(isCorrect: Bool) {
        judgeImageView.image = isCorrect ? Images.correct : Images.incorrect
    }
}
