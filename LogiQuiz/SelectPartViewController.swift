//
//  SelectPartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/18.
//

import UIKit

class SelectPartViewController: UIViewController {
    enum Const {
        static let borderWidth: CGFloat = 2
        static let bordercolor = UIColor.black.cgColor
    }

    @IBOutlet private weak var part1Button: UIButton!

    @IBOutlet private weak var part2Button: UIButton!


    @IBOutlet weak var part3Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        part1Button.layer.borderWidth = Const.borderWidth
        part1Button.layer.borderColor = Const.bordercolor
        part2Button.layer.borderWidth = 2
        part2Button.layer.borderColor = UIColor.black.cgColor
        part3Button.layer.borderWidth = 2
        part3Button.layer.borderColor = UIColor.black.cgColor
    }

    //    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
    //
    //    }

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
