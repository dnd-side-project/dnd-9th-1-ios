//
//  Goal.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/21.
//

import Foundation
import RxDataSources

struct GoalResponse<T: Codable>: Codable {
    let contents: [T]
    let next: Bool
}

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
