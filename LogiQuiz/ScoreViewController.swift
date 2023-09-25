//
//  ScoreViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit
import StoreKit

final class ScoreViewController: UIViewController {

    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton! {
        didSet {
            shareButton.layer.borderWidth = ButtonBorder.borderWidth
            shareButton.layer.borderColor = ButtonBorder.bordercolor
        }
    }
    
    @IBOutlet private weak var returnTopButton: UIButton! {
        didSet {
            returnTopButton.layer.borderWidth = ButtonBorder.borderWidth
            returnTopButton.layer.borderColor = ButtonBorder.bordercolor
        }
    }
    
    
    var correct = 0
    var questionnum = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "\(questionnum)問中、\(correct)問正解！"
    }
    
    @IBAction private func shareButtonAction(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let activityItems = ["\(questionnum)問中、\(correct)問正解しました。"+"https://apps.apple.com/us/app/logiquiz/id6450583773"]

            //共有画面の表示
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC,animated:true)
    }
    
    @IBAction private func toTopButtonAction(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        //スタート画面に遷移
        navigationController?.popToRootViewController(animated: true)
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
}
