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
        }
    }

    private func updateUI(with quiz: Quiz, isWrong: Bool) {
        quizNumberLabel.text = "問題 \(quizViewModel.currentQuizIndex + 1)"
        quizTextView.text = quiz.title
        answerButton1.setTitle(quiz.selections[0], for: .normal)
        answerButton2.setTitle(quiz.selections[1], for: .normal)
        checkBoxButton.isSelected = isWrong
        let imageName = checkBoxButton.isSelected ? "box_checked" : "box_unchecked"
        checkBoxButton.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func checkBoxTapped(_ sender: Any) {
        quizViewModel.toggleWrongQuizStatus()
    }

    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        quizViewModel.answerSelected(at: sender.tag - 1)
    }
}
