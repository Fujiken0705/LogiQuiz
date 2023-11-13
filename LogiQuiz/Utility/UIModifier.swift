//
//  UIModifier.swift
//  LogiQuiz
//
//  Created by KentoFujita on 2023/09/01.
//

import UIKit

extension UIButton {
    func applyStandardStyle() {
        self.layer.borderWidth = ButtonBorder.borderWidth
        self.layer.borderColor = ButtonBorder.bordercolor
    }
}

enum ButtonBorder {
    static let borderWidth: CGFloat = 2
    static let bordercolor = UIColor.black.cgColor
}
