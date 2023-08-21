//
//  DetailGoal.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/21.
//

import Foundation

struct DetailGoal: Codable {
    let title: String
    let alarmEnabled: Bool
    let alarmTime: String
    let alarmDays: [String]
}