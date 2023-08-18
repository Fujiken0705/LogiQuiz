//
//  ScoreViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit

final class ScoreViewController: UIViewController {
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    
    @IBOutlet private weak var returnTopButton: UIButton!
    
    
    var correct = 0
    var questionnum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(questionnum + 1)問中、\(correct)問正解！"
        
        shareButton.layer.borderWidth = 2
        shareButton.layer.borderColor = UIColor.black.cgColor
        returnTopButton.layer.borderWidth = 2
        returnTopButton.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func shareButtonAction(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let activityItems = ["\(questionnum)問中、\(correct)問正解しました。"+"LogiQuiz"+""]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC,animated:true)
    }
    
    @IBAction private func toTopButtonAction(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        navigationController?.popToRootViewController(animated: true)
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
