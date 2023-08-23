//
//  Goal.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/21.
//

import Foundation
import RxDataSources

struct GoalResponse: Codable {
    let contents: [ParentGoal]
    let next: Bool
}

// TODO: - 상위 목표 수정 req 모델

struct Goal: Codable, IdentifiableType, Equatable {
    let identity: Int
    let title: String
    let startDate: String
    let endDate: String
    let reminderEnabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case identity = "goalId"
        case title = "title"
        case startDate = "startDate"
        case endDate = "endDate"
        case reminderEnabled = "reminderEnabled"
    }
}
