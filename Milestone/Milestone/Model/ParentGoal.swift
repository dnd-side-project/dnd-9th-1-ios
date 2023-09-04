//
//  CompletedGoal.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/22.
//

import Foundation
import RxDataSources

// MARK: - 상위 목표 조회 Res 모델

struct GoalResponse: Codable {
    let contents: [ParentGoal]
    let next: Bool
}

// MARK: - 상위 목표 모델 (채움함, 완료함, 보관함에 사용)

struct ParentGoal: Codable {
    let goalId: Int
    let title: String
    let startDate: String
    let endDate: String
    let entireDetailGoalCnt: Int
    let completedDetailGoalCnt: Int
    let dDay: Int
    let hasRetrospect: Bool
    let reminderEnabled: Bool
    let reward: String?
}

// MARK: - 상위 목표 개수 모델

struct ParentGoalCount: Codable {
    var counts: Count
}

struct Count: Codable {
    var STORE: Int
    var PROCESS: Int
    var COMPLETE: Int
}

// MARK: - 상위 목표 생성 모델

struct CreateParentGoal: Codable {
    var title: String
    var startDate: String
    var endDate: String
    var reminderEnabled: Bool
}

// MARK: - 상위 목표 수정, 복구 req 모델

struct Goal: Codable, IdentifiableType, Equatable {
    let identity: Int?
    let title: String?
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

// MARK: - 상위 목표 수정 res 모델

struct ParentGoalInfo: Codable {
    let goalId: Int
    let title: String
    let startDate: String
    let endDate: String
    let dDay: Int
}
