//
//  UIColor+.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/05.
//

import UIKit

extension UIColor {
    static var primary: UIColor {
        return UIColor(hex: "#408DF2")
    }
    static var secondary01: UIColor {
        return UIColor(hex: "#98CEFF")
    }
    static var secondary02: UIColor {
        return UIColor(hex: "#BFE0FF")
    }
    static var secondary03: UIColor {
        return UIColor(hex: "EDF6FF")
    }
    static var black: UIColor {
        return UIColor(hex: "#232930")
    }
    static var gray01: UIColor {
        return UIColor(hex: "#F3F4F6")
    }
    static var gray02: UIColor {
        return UIColor(hex: "#C0C7D0")
    }
    static var gray03: UIColor {
        return UIColor(hex: "#787f88")
    }
    static var gray04: UIColor {
        return UIColor(hex: "#646a73")
    }
    static var gray05: UIColor {
        return UIColor(hex: "#444B53")
    }
    static var gray06: UIColor {
        return UIColor(hex: "#32373E")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
