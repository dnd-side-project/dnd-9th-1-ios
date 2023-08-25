//
//  DetailGoal.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/21.
//

import Foundation

// MARK: - 세부 목표 모델

struct DetailGoal: Codable {
    let detailGoalId: Int
    let title: String
    var isCompleted: Bool
}

// MARK: - 세부 목표 생성 시 req 모델

struct CreateDetailGoal {
    let title: String
    let alarmEnabled: Bool
    let alarmTime: String
    let alarmDays: [String]
}


// MARK: - 세부 목표 완료 시 res 모델

struct CompletedDetailGoal: Codable {
    var isGoalCompleted: Bool
    var rewardType: String?
    var completedGoalCount: Int
}
