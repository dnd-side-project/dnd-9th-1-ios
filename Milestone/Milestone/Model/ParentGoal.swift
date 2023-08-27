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

struct ParentGoal: Codable, IdentifiableType, Equatable {
    let identity: Int
    let reward: String?
    let endDate: String
    let startDate: String
    let title: String
    let completedDetailGoalCnt: Int
    let entireDetailGoalCnt: Int
    let hasRetrospect: Bool
    let dDay: Int
    
    enum CodingKeys: String, CodingKey {
        case identity = "goalId"
        case reward = "reward"
        case endDate = "endDate"
        case startDate = "startDate"
        case title = "title"
        case completedDetailGoalCnt = "completedDetailGoalCnt"
        case entireDetailGoalCnt = "entireDetailGoalCnt"
        case hasRetrospect = "hasRetrospect"
        case dDay = "dDay"
    }
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

// MARK: - 상위 목표 수정 req 모델

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

// MARK: - 상위 목표 수정 res 모델

struct ParentGoalInfo: Codable {
    let goalId: Int
    let title: String
    let startDate: String
    let endDate: String
    let dDay: Int
}
