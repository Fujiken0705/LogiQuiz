//
//  StartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit

final class StartViewController: UIViewController {

    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var sendFormButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.accessibilityIdentifier = "startButton"
        startButton.applyStandardStyle()
        sendFormButton.applyStandardStyle()
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
