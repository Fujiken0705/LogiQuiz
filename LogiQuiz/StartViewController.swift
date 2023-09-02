//
//  StartViewController.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/05/16.
//

import UIKit

final class StartViewController: UIViewController {

    @IBOutlet private weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderWidth = ButtonBorder.borderWidth
        startButton.layer.borderColor = ButtonBorder.bordercolor
    }

    @IBAction private func startButtonTapped(_ sender: UIButton) {
        let selectPartVC = SelectPartViewController(nibName: "SelectPartViewController", bundle: nil)
        navigationController?.pushViewController(selectPartVC, animated: true)
    }

}
