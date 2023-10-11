//
//  QuizViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit

final class QuizViewController: UIViewController {
    
    @IBOutlet private weak var quizNumberLabel: UILabel!
    @IBOutlet private weak var quizTextView: UITextView!
    @IBOutlet private weak var answerButton1: UIButton!
    @IBOutlet private weak var answerButton2: UIButton!
    @IBOutlet private weak var judgeImageView: UIImageView!
    @IBOutlet private weak var checkBoxButton: UIButton!

    var quizViewModel: QuizViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        quizViewModel.eventHandler = { [weak self] event in
            DispatchQueue.main.async {
                self?.handle(event: event)
            }
        }
        quizViewModel.loadCSV()

        if let quiz = quizViewModel.currentQuiz() {
            let isWrong = quizViewModel.wrongQuizzes.contains(quiz.id)
            updateUI(with: quiz, isWrong: isWrong)
        }

        quizTextView.accessibilityIdentifier = "quizTextView"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScoreVC",
           let scoreViewController = segue.destination as? ScoreViewController {
            scoreViewController.correct = quizViewModel.correctCount
            scoreViewController.questionnum = quizViewModel.currentQuizIndex
        }
    }

    private func handle(event: QuizViewModel.Event) {
        switch event {
        case .errorOccurred(let message):
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        case .updateUI(let quiz, let isWrong):
            updateUI(with: quiz, isWrong: isWrong)
        case .moveToResultScreen:
            let scoreViewController = ScoreViewController(nibName: "ScoreViewController", bundle: nil)
            scoreViewController.correct = quizViewModel.correctCount
            scoreViewController.questionnum = quizViewModel.currentQuizIndex
            navigationController?.pushViewController(scoreViewController, animated: true)
        }
    }

    private func updateUI(with quiz: Quiz, isWrong: Bool) {
        quizNumberLabel.text = "問題 \(quizViewModel.currentQuizIndex + 1)"
        quizTextView.text = quiz.title
        answerButton1.setTitle(quiz.selections[0], for: .normal)
        answerButton2.setTitle(quiz.selections[1], for: .normal)

        switch quizViewModel.checkBoxState {
        case .unchecked:
            checkBoxButton.setImage(UIImage(named: "box_unchecked"), for: .normal)
        case .checkedByUser, .checkedBySystem:
            checkBoxButton.setImage(UIImage(named: "box_checked"), for: .normal)
            //うまく表示が切り替わらないので後日対処する
        }
    }

    @IBAction func checkBoxTapped(_ sender: Any) {
        quizViewModel.toggleWrongQuizStatus(byUser: true)
    }

    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        //連続タップの無効化
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false

        let isCorrect = quizViewModel.answerSelected(at: sender.tag - 1)
        judgeImageView.isHidden = false
        playSound(isCorrect: isCorrect)
        updateCorrectUI(isCorrect: isCorrect)

        // 正誤判定画像の非表示の遅延処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            self.judgeImageView.isHidden = true

            // ボタンの再有効化
            answerButton1.isEnabled = true
            answerButton2.isEnabled = true
        }
    }

    private func playSound(isCorrect: Bool) {
        Player.play(soundURL: isCorrect ? SoundURL.correct : SoundURL.incorrect)
    }

    private func updateCorrectUI(isCorrect: Bool) {
        judgeImageView.image = isCorrect ? Images.correct : Images.incorrect
    }
}
