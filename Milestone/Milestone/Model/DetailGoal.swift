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
