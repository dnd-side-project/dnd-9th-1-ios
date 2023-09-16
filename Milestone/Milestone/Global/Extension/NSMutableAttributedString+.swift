//
//  NSMutableAttributedString+.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/13.
//

import UIKit

extension NSMutableAttributedString {

    /// AttributedString 원하는 문자에 여러 색들을 섞을 수 있는 익스텐션
    /// let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
    /// attributedString.setColorForText(textForAttribute: "stack", withColor: UIColor.black)
    /// attributedString.setColorForText(textForAttribute: "over", withColor: UIColor.orange)
    /// attributedString.setColorForText(textForAttribute: "flow", withColor: UIColor.red)
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)

        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
