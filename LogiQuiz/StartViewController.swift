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

    @IBOutlet private weak var informButton: UIButton! {
        didSet {
            informButton.layer.borderWidth = ButtonBorder.borderWidth
            informButton.layer.borderColor = ButtonBorder.bordercolor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func startButtonTapped(_ sender: UIButton) {
        let selectPartVC = SelectPartViewController(nibName: "SelectPartViewController", bundle: nil)
        navigationController?.pushViewController(selectPartVC, animated: true)
    }

    @IBAction func informButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://forms.gle/fwxyq7EJ2VjP6Ls57") else { return }
            UIApplication.shared.open(url)
    }

}
