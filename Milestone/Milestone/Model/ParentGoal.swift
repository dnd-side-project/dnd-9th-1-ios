//
//  CompletedGoal.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/22.
//

import Foundation
import RxDataSources

// MARK: - 상위 목표 모델 (채움함, 완료함, 보관함에 사용)

struct ParentGoal: Codable, IdentifiableType, Equatable {
    let identity: Int
    let reward: String
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
