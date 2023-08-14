//
//  DetailGoal.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/13.
//

import Foundation

// MARK: - 세부 목표 데이터 모델

struct DetailGoal {
    var id: Int = 0 // 작성순을 위해 임시로 넣어놓은 값
    var isSet: Bool = true
    var isCompleted: Bool = false
    var title: String = ""
}
