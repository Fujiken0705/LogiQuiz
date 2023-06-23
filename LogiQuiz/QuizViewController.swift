//
//  QuizViewController.swift
//  SampleQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet weak var quizTextView: UITextView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var judgeImageView: UIImageView!


    var csvArrey: [String] = []
    var quizArrey: [String] = []
    var quizCount = 0
    var correctCount = 0
    var selectLevel = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("選択したのはレベル\(selectLevel)")

        csvArrey = loadCSV(filename: "Quiz\(selectLevel)")

        csvArrey.shuffle()
        quizArrey = csvArrey[quizCount].components(separatedBy: ",")
        quizNumberLabel.text = "第\(quizCount + 1)問"
        quizTextView.text = quizArrey[0]
        answerButton1.setTitle(quizArrey[2], for: .normal)
        answerButton2.setTitle(quizArrey[3], for: .normal)

        answerButton1.layer.borderWidth = 2
        answerButton1.layer.borderColor = UIColor.black.cgColor
        answerButton2.layer.borderWidth = 2
        answerButton2.layer.borderColor = UIColor.black.cgColor
    }

    //QuizViewの正解数をScoreViewに受け渡す
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
        scoreVC.questionnum = quizCount
    }

    @IBAction func btnAction(sender : UIButton) {
        if sender.tag == Int(quizArrey[1]){
            correctCount += 1
            print("正解")
            judgeImageView.image = UIImage(named: "correct")
        } else {
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
        }
        print("スコア\(correctCount)")
        judgeImageView.isHidden = false
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.judgeImageView.isHidden = true
            self.answerButton1.isEnabled = true
            self.answerButton2.isEnabled = true
            self.nextQuiz()
        }
    }

    func nextQuiz() {
        quizCount += 1
        if quizCount < csvArrey.count{
            quizArrey = csvArrey[quizCount].components(separatedBy: ",")
            quizNumberLabel.text = "第\(quizCount + 1)問"
            quizTextView.text = quizArrey[0]
            answerButton1.setTitle(quizArrey[2], for: .normal)
            answerButton2.setTitle(quizArrey[3], for: .normal)
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }

    }


    func loadCSV(filename: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: filename, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArrey = lineChange.components(separatedBy: "\n")
            csvArrey.removeLast()
        } catch {
            print("エラー")
        }
        return csvArrey
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
