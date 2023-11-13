//
//  SelectPartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/18.
//

import UIKit
import RealmSwift

final class SelectPartViewController: UIViewController {

    @IBOutlet private weak var part1Button: UIButton!
    @IBOutlet private weak var part2Button: UIButton!
    @IBOutlet private weak var part3Button: UIButton!
    @IBOutlet private weak var part4Button: UIButton!
    @IBOutlet private weak var part5Button: UIButton!
    @IBOutlet private weak var part6Button: UIButton!
    @IBOutlet private weak var part7Button: UIButton!
    @IBOutlet private weak var part8Button: UIButton!
    @IBOutlet private weak var reviewButton: UIButton!


    private var selectPartViewModel = SelectPartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "パートを選択"

        setupButtons()
    }

    private func setupButtons() {
        part1Button.applyStandardStyle()
        part2Button.applyStandardStyle()
        part3Button.applyStandardStyle()
        part4Button.applyStandardStyle()
        part5Button.applyStandardStyle()
        part6Button.applyStandardStyle()
        part7Button.applyStandardStyle()
        part8Button.applyStandardStyle()
        reviewButton.applyStandardStyle()
    }


    @IBAction private func PartButtonTapped(sender:UIButton) {
        //パート番号の受け渡しがされているか確認する。
        print(sender.tag)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        //クイズ画面に遷移
        let quizVC = QuizViewController(nibName: "QuizViewController", bundle: nil)
        quizVC.quizViewModel = QuizViewModel(selectPart: sender.tag)
        navigationController?.pushViewController(quizVC, animated: true)
    }


    @IBAction private func reviewButtonTapped(_ sender: Any) {

        //問題をうまく表示できなかった場合のアラートを出す
        if selectPartViewModel.shouldPresentAlertForEmptyQuizzes() {
            let alertController = UIAlertController(title: "エラー", message: "復習する問題がありません。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
            return
        }


        let wrongQuizIds = selectPartViewModel.wrongQuizIds()

        for quizId in wrongQuizIds {
            if let quiz = selectPartViewModel.fetchQuiz(from: quizId) {
                print("Successfully fetched quiz for ID \(quizId): \(quiz.title)")
            } else {
                print("Failed to fetch quiz for ID \(quizId)")
            }
        }

        let quizViewController = QuizViewController(nibName: "QuizViewController", bundle: nil)
        quizViewController.quizViewModel = QuizViewModel(selectPart: 0, specificQuizIds: wrongQuizIds)
        navigationController?.pushViewController(quizViewController, animated: true)
    }
}
