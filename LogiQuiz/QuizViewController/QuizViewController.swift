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
        answerButton1.applyStandardStyle()
        answerButton2.applyStandardStyle()
        judgeImageView.isHidden = true
        quizViewModel.eventHandler = { [weak self] event in
            DispatchQueue.main.async {
                self?.handle(event: event)
            }
        }
        quizViewModel.loadCSV()
        updateUIForCurrentQuiz()
        quizTextView.accessibilityIdentifier = "quizTextView"

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScoreVC",
           let scoreViewController = segue.destination as? ScoreViewController {
            scoreViewController.correct = quizViewModel.correctCount
            scoreViewController.questionnum = quizViewModel.currentQuizIndex
        }
    }

    private func updateUIForCurrentQuiz() {
        if let quiz = quizViewModel.currentQuiz() {
            let isWrong = quizViewModel.wrongQuizzes.contains(quiz.id)
            updateUI(with: quiz, isWrong: isWrong)
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

        // 現在のクイズが間違ったクイズリストに含まれているかどうかでチェックボックスの状態を更新
        if isWrong {
            checkBoxButton.setImage(UIImage(named: "box_checked"), for: .normal)
        } else {
            checkBoxButton.setImage(UIImage(named: "box_unchecked"), for: .normal)
        }
    }

    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        // 連続タップの無効化
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false

        let isCorrect = quizViewModel.answerSelected(at: sender.tag - 1)

        // 正誤の画像を表示
        updateCorrectUI(isCorrect: isCorrect)
        judgeImageView.isHidden = false
        playSound(isCorrect: isCorrect)

        // 正誤判定画像の非表示の遅延処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            self.judgeImageView.isHidden = true

            // ボタンの再有効化
            self.answerButton1.isEnabled = true
            self.answerButton2.isEnabled = true

            // UIの更新
            if let currentQuiz = self.quizViewModel.currentQuiz() {
                // 正解の場合、不正解リストから削除し、間違いがある場合は追加する
                let isWrong = self.quizViewModel.wrongQuizzes.contains(currentQuiz.id)
                self.updateUI(with: currentQuiz, isWrong: isWrong)
            }
        }
    }

    private func playSound(isCorrect: Bool) {
        Player.play(soundURL: isCorrect ? SoundURL.correct : SoundURL.incorrect)
    }

    private func updateCorrectUI(isCorrect: Bool) {
        judgeImageView.image = isCorrect ? Images.correct : Images.incorrect
    }
}
