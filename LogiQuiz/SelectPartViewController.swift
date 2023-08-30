//
//  SelectPartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/18.
//

import UIKit
import RealmSwift

final class SelectPartViewController: UIViewController {
    enum Const {
        static let borderWidth: CGFloat = 2
        static let bordercolor = UIColor.black.cgColor
    }

    @IBOutlet private weak var part1Button: UIButton! {
        didSet {
            part1Button.layer.borderWidth = Const.borderWidth
            part1Button.layer.borderColor = Const.bordercolor
        }
    }

    @IBOutlet private weak var part2Button: UIButton! {
        didSet {
            part2Button.layer.borderWidth = Const.borderWidth
            part2Button.layer.borderColor = Const.bordercolor
        }
    }


    @IBOutlet private weak var part3Button: UIButton! {
        didSet {
            part3Button.layer.borderWidth = Const.borderWidth
            part3Button.layer.borderColor = Const.bordercolor
        }
    }

    @IBOutlet private weak var reviewButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // 特定のリソース名に対して期待されるファイルパスを取得して印刷
        let resourceNames = ["Quiz1", "Quiz2", "Quiz3"]
        for resourceName in resourceNames {
            if let filePath = Bundle.main.path(forResource: resourceName, ofType: "csv") {
                print("File path for \(resourceName): \(filePath)")
            } else {
                print("Failed to find file path for \(resourceName)")
            }
        }
        // 特定の問題ID（例: "p1q3"）を使用して、fetchQuizメソッドをテスト
        if let testQuiz = fetchQuiz(from: "p1q3") {
            print("Fetched quiz for p1q3: \(testQuiz.title)")
        } else {
            print("Failed to fetch quiz for p1q3")
        }
    }


    @IBAction private func PartButtonAction(sender:UIButton) {
        print(sender.tag)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let quizVC = QuizViewController(nibName: "QuizViewController", bundle: nil)
        quizVC.viewModel = QuizViewModel(selectPart: sender.tag)
        navigationController?.pushViewController(quizVC, animated: true)
    }

    private func fetchWrongQuizzes() -> [WrongQuiz] {
        let realm = try! Realm()
        return Array(realm.objects(WrongQuiz.self))
    }

    private func fetchQuiz(from quizId: String) -> Quiz? {
        print("Fetching quiz for ID: \(quizId)")

        let parts = quizId.split(separator: "q")
        guard let part = parts.first, let index = Int(parts.last ?? "") else {
            print("Failed to split quizId: \(quizId) into part and index")
            return nil
        }

        let resourceName = "Quiz\(part.dropFirst())"
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "csv") else {
            print("Failed to find CSV for resource name: \(resourceName)")
            return nil
        }

        do {
            let csvData = try String(contentsOfFile: filePath)
            let csvLines = csvData.components(separatedBy: .newlines)
            guard index <= csvLines.count else {
                print("Index out of range for quizId: \(quizId)")
                return nil
            }
            let line = csvLines[index - 1]
            let components = line.components(separatedBy: ",")
            guard components.count >= 3 else {
                print("Insufficient data for quizId: \(quizId)")
                return nil
            }
            let title = components[0]
            let correctIndex = (Int(components[1]) ?? 1) - 1
            let selections = Array(components[2...])
            return Quiz(id: quizId, title: title, selections: selections, correctIndex: correctIndex)
        } catch {
            print("Error reading CSV for quiz id: \(quizId), error: \(error)")
            return nil
        }
    }


    @IBAction private func reviewButtonTapped(_ sender: Any) {
        let wrongQuizzes = fetchWrongQuizzes()
        print("Wrong Quiz IDs: \(wrongQuizzes.map { $0.quizid })")

        // 間違えた問題のIDの配列を作成
        let wrongQuizIds = wrongQuizzes.map { $0.quizid }

        // 間違ったクイズIDに対して、クイズの情報を取得する
        for quizId in wrongQuizIds {
            if let quiz = fetchQuiz(from: quizId) {
                print("Successfully fetched quiz for ID \(quizId): \(quiz.title)")
            } else {
                print("Failed to fetch quiz for ID \(quizId)")
            }
        }

        // 間違えた問題を表示する`QuizViewController`を準備
        let quizViewController = QuizViewController(nibName: "QuizViewController", bundle: nil)

        // 間違えた問題のIDの配列をもとに`QuizViewModel`を初期化
        quizViewController.viewModel = QuizViewModel(selectPart: 0, specificQuizIds: wrongQuizIds)

        // 間違えた問題を表示する`QuizViewController`をpush
        navigationController?.pushViewController(quizViewController, animated: true)
    }

}
