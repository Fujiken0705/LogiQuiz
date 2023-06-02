//
//  ScoreViewController.swift
//  SampleQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var returnTopButton: UIButton!


    var correct = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = "\(correct)問正解！"

        shareButton.layer.borderWidth = 2
        shareButton.layer.borderColor = UIColor.black.cgColor
        returnTopButton.layer.borderWidth = 2
        returnTopButton.layer.borderColor = UIColor.black.cgColor

        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonAction(_ sender: Any) {
        let activityItems = ["\(correct)問正解しました。","クイズアプリ"]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC,animated:true)
    }

    @IBAction func toTopButtonAction(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated:true)
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
