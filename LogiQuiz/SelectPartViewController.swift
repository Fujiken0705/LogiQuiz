//
//  SelectPartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/18.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func PartButtonAction(sender:UIButton) {
        print(sender.tag)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let quizVC = QuizViewController(nibName: "QuizViewController", bundle: nil)
        quizVC.viewModel = QuizViewModel(selectPart: sender.tag)
        navigationController?.pushViewController(quizVC, animated: true)
        print("押されてはいるよ")
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
