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

// MARK: - 세부 목표 생성 및 수정 시 req 모델

struct NewDetailGoal: Codable {
    let title: String
    let alarmEnabled: Bool
    let alarmTime: String
    let alarmDays: [String]
}

// MARK: - 세부 목표 상세 res 모델

struct DetailGoalInfo: Codable {
    var detailGoalId: Int
    var title: String
    var alarmTime: String
    var alarmDays: [String]
    var alarmEnabled: Bool
}

// MARK: - 세부 목표 완료 및 삭제 시 res 모델

struct StateUpdatedDetailGoal: Codable {
    var isGoalCompleted: Bool
    var rewardType: String?
    var completedGoalCount: Int
}
