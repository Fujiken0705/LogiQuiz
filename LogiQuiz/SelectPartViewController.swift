//
//  SelectLevelViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/18.
//

import UIKit

class SelectPartViewController: UIViewController {


    @IBOutlet weak var part1Button: UIButton!

    @IBOutlet weak var part2Button: UIButton!


    @IBOutlet weak var part3Button: UIButton!
    var selectTag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        part1Button.layer.borderWidth = 2
        part1Button.layer.borderColor = UIColor.black.cgColor
        part2Button.layer.borderWidth = 2
        part2Button.layer.borderColor = UIColor.black.cgColor
        part3Button.layer.borderWidth = 2
        part3Button.layer.borderColor = UIColor.black.cgColor
    }

    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        let quizVC = segue.destination as! QuizViewController
        quizVC.selectLevel = selectTag
    }

    @IBAction func PartButtonAction(sender:UIButton) {
        print(sender.tag)
        selectTag = sender.tag
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        performSegue(withIdentifier: "toQuizVC", sender: nil)
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
