//
//  StartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit

final class StartViewController: UIViewController {

    @IBOutlet private weak var startButton: UIButton! {
        didSet {
            startButton.layer.borderWidth = ButtonBorder.borderWidth
            startButton.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    @IBOutlet private weak var sendFormButton: UIButton! {
        didSet {
            sendFormButton.layer.borderWidth = ButtonBorder.borderWidth
            sendFormButton.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.accessibilityIdentifier = "startButton"
    }

    @IBAction private func startButtonTapped(_ sender: UIButton) {
        let selectPartVC = SelectPartViewController(nibName: "SelectPartViewController", bundle: nil)
        navigationController?.pushViewController(selectPartVC, animated: true)
    }

    @IBAction func sendFormButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://forms.gle/fwxyq7EJ2VjP6Ls57") else { return }
            UIApplication.shared.open(url)
    }

}
