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
    }

    @IBAction private func PartButtonAction(sender:UIButton) {
        print(sender.tag)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let quizVC = QuizViewController(nibName: "QuizViewController", bundle: nil)
        quizVC.viewModel = QuizViewModel(selectPart: sender.tag)
        navigationController?.pushViewController(quizVC, animated: true)
    }

    func fetchWrongQuizzes() -> [WrongQuiz] {
        let realm = try! Realm()
        return Array(realm.objects(WrongQuiz.self))
    }

    func fetchQuiz(from quizId: String) -> Quiz? {
        let parts = quizId.split(separator: "q")
        guard let part = parts.first, let index = Int(parts.last ?? "") else {
            return nil
        }

        let filePath = Bundle.main.path(forResource: "Quiz\(part.dropFirst())", ofType: "csv")
        do {
            let csvData = try String(contentsOfFile: filePath!)
            let csvLines = csvData.components(separatedBy: .newlines)
            let line = csvLines[index - 1]
            let components = line.components(separatedBy: ",")
            let title = components[0]
            let correctIndex = (Int(components[1]) ?? 1) - 1
            let selections = Array(components[2...])
            return Quiz(id: quizId, title: title, selections: selections, correctIndex: correctIndex)
        } catch {
            print("Error reading CSV for quiz id: \(quizId)")
            return nil
        }
    }


    @IBAction func reviewButtonTapped(_ sender: Any) {
        let wrongQuizzes = fetchWrongQuizzes()

        // 間違えた問題のIDの配列を作成
        let wrongQuizIds = wrongQuizzes.map { $0.quizid }

        // 間違えた問題を表示する`QuizViewController`を準備
        let quizViewController = QuizViewController(nibName: "QuizViewController", bundle: nil)

        // 間違えた問題のIDの配列をもとに`QuizViewModel`を初期化
        quizViewController.viewModel = QuizViewModel(selectPart: 0, specificQuizIds: wrongQuizIds) // selectPartは0としておきます。specificQuizIdsのみを使用するためです。

        // 間違えた問題を表示する`QuizViewController`をpush
        navigationController?.pushViewController(quizViewController, animated: true)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
