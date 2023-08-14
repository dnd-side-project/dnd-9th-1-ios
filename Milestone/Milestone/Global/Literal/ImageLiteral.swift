//
//  ImageLiteral.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import UIKit

// MARK: - Assets에 새 이미지 추가 시 여기에도 추가해두기!

enum ImageLiteral {
    static var imgSetting: UIImage { .load(named: "setting")}
    static var imgTempStone: UIImage { .load(named: "tempStone")}
    static var imgCalendar: UIImage { .load(named: "calendar")}
    static var imgTempGoal: UIImage { .load(named: "tempGoal")}
    static var imgPlus: UIImage { .load(named: "plus")}
    static var imgOnboarding: UIImage { .load(named: "onboarding2") }
}
