//
//  QuizViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit
import AudioToolbox
import RealmSwift

final class QuizViewController: UIViewController {
    
    @IBOutlet private weak var quizNumberLabel: UILabel!
    @IBOutlet private weak var quizTextView: UITextView!
    @IBOutlet private weak var answerButton1: UIButton!
    @IBOutlet private weak var answerButton2: UIButton!
    @IBOutlet private weak var judgeImageView: UIImageView!
    @IBOutlet private weak var checkBoxButton: UIButton!

    var viewModel: QuizViewModel!
    
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
        let quizId = "p\(viewModel.selectPart)q\(viewModel.currentQuizIndex + 1)"

        // Realmを使用して、そのIDの問題が間違えた問題リストに存在するかどうかを確認
        let realm = try! Realm()
        let isWrongQuiz = !realm.objects(WrongQuiz.self).filter("quizid == %@", quizId).isEmpty

        // 存在する場合、チェックボックスにチェックを入れる
        checkBoxButton.isSelected = isWrongQuiz
        let imageName = isWrongQuiz ? "box_checked" : "box_unchecked"
        checkBoxButton.setImage(UIImage(named: imageName), for: .normal)

        // その他のUIの更新
        quizNumberLabel.text = "問題 \(viewModel.currentQuizIndex + 1)"
        quizTextView.text = quiz.title
        answerButton1.setTitle(quiz.selections[0], for: .normal)
        answerButton2.setTitle(quiz.selections[1], for: .normal)
    }


    @IBAction func checkBoxTapped(_ sender: Any) {
        checkBoxButton.isSelected.toggle() // 状態を切り替える
        let imageName = checkBoxButton.isSelected ? "box_checked" : "box_unchecked"
        checkBoxButton.setImage(UIImage(named: imageName), for: .normal)

    }
    
    private func saveWrongQuiz() {
        let wrongQuiz = WrongQuiz()
        wrongQuiz.quizid = "p\(viewModel.selectPart)q\(viewModel.currentQuizIndex + 1)"

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(wrongQuiz)
            }
        } catch {
            print("Failed to save wrong quiz: \(error)")
        }
    }

    private func removeWrongQuiz() {
        let quizId = "p\(viewModel.selectPart)q\(viewModel.currentQuizIndex + 1)"
        do {
            let realm = try Realm()
            if let wrongQuiz = realm.objects(WrongQuiz.self).filter("quizid == %@", quizId).first {
                try realm.write {
                    realm.delete(wrongQuiz)
                }
            }
        } catch {
            print("Failed to remove wrong quiz: \(error)")
        }
    }
    
    @IBAction private func answerButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false  // ボタンを無効化
        let isCorrect = viewModel.checkAnswer(sender.tag - 1)
        self.judgeImageView.isHidden = false
        isCorrect ? Vibration.playcorrect() : Vibration.playincorrect()
        playSound(isCorrect: isCorrect)
        updateCorrectUI(isCorrect: isCorrect)
        if isCorrect {
            if checkBoxButton.isSelected {
                checkBoxButton.isSelected = false
                checkBoxButton.setImage(UIImage(named: "box_unchecked"), for: .normal)
                removeWrongQuiz()  // 正解した問題を間違えた問題リストから削除
            }
        } else {
            if !checkBoxButton.isSelected {
                checkBoxButton.isSelected = true
                checkBoxButton.setImage(UIImage(named: "box_checked"), for: .normal)
                saveWrongQuiz()  // 間違えた問題を保存
            }
        }
        if viewModel.nextQuiz() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateQuizzes()
                self.judgeImageView.isHidden = true
                sender.isEnabled = true  // ボタンを再度有効化
            }
        } else {
            let scoreViewController = ScoreViewController(nibName: "ScoreViewController", bundle: nil)
            scoreViewController.correct = viewModel.correctCount
            scoreViewController.questionnum = viewModel.currentQuizIndex
            navigationController?.pushViewController(scoreViewController, animated: true)
        }
    }
    
    private func playSound(isCorrect: Bool) {
        Player.play(soundURL: isCorrect ? SoundURL.correct : SoundURL.incorrect)
    }
    
    private func updateCorrectUI(isCorrect: Bool) {
        judgeImageView.image = isCorrect ? Images.correct : Images.incorrect
    }
}
