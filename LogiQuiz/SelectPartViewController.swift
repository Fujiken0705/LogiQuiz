//
//  SelectPartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/18.
//

import UIKit
import RealmSwift

final class SelectPartViewController: UIViewController {

    @IBOutlet private weak var part1Button: UIButton! {
        didSet {
            part1Button.layer.borderWidth = ButtonBorder.borderWidth
            part1Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet private weak var part2Button: UIButton! {
        didSet {
            part2Button.layer.borderWidth = ButtonBorder.borderWidth
            part2Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }


    @IBOutlet private weak var part3Button: UIButton! {
        didSet {
            part3Button.layer.borderWidth = ButtonBorder.borderWidth
            part3Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet weak var part4Button: UIButton! {
        didSet {
            part4Button.layer.borderWidth = ButtonBorder.borderWidth
            part4Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet weak var part5Button: UIButton! {
        didSet {
            part5Button.layer.borderWidth = ButtonBorder.borderWidth
            part5Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet weak var part6Button: UIButton! {
        didSet {
            part6Button.layer.borderWidth = ButtonBorder.borderWidth
            part6Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet weak var part7Button: UIButton! {
        didSet {
            part7Button.layer.borderWidth = ButtonBorder.borderWidth
            part7Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet weak var part8Button: UIButton! {
        didSet {
            part8Button.layer.borderWidth = ButtonBorder.borderWidth
            part8Button.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet private weak var reviewButton: UIButton! {
        didSet {
            reviewButton.layer.borderWidth = ButtonBorder.borderWidth
            reviewButton.layer.borderColor = ButtonBorder.bordercolor
        }
    }


    private var selectPartViewModel = SelectPartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "パートを選択" 
    }


    @IBAction private func PartButtonTapped(sender:UIButton) {
        //パート番号の受け渡しがされているか確認する。
        print(sender.tag)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        //クイズ画面に遷移
        let quizVC = QuizViewController(nibName: "QuizViewController", bundle: nil)
        quizVC.viewModel = QuizViewModel(selectPart: sender.tag)
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
        quizViewController.viewModel = QuizViewModel(selectPart: 0, specificQuizIds: wrongQuizIds)
        navigationController?.pushViewController(quizViewController, animated: true)
    }

}
