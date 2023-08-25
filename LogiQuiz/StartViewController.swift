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
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction private func startButtonTapped(_ sender: UIButton) {
        let selectPartVC = SelectPartViewController(nibName: "SelectPartViewController", bundle: nil)
        navigationController?.pushViewController(selectPartVC, animated: true)
    }

}
