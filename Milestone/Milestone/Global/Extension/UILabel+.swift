//
//  UILabel+.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/05.
//

import UIKit

extension UILabel {
    func applyColor(to targetString: String, with color: UIColor) {
        if let labelText = self.text, !labelText.isEmpty {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.foregroundColor,
                                          value: color,
                                          range: (labelText as NSString).range(of: targetString))
            attributedText = attributedString
        }
    }
    
    func applyFont(to targetString: String, with font: UIFont) {
        if let labelText = self.text, !labelText.isEmpty {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(.font,
                                          value: font,
                                          range: (labelText as NSString).range(of: targetString))
            attributedText = attributedString
        }
    }
}
