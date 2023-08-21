//
//  ParentGoal.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/21.
//

import Foundation

// MARK: - 상위 목표 데이터 모델

struct ParentGoal {
    var id: Int = 0 // 작성순을 위해 임시로 넣어놓은 값
    var totalGoalNum: Int = 9
    var completedGoalNum: Int = 1
    var title: String = "마일스톤 런칭하기"
    var startDate: String = "2023.08.08"
    var endDate: String = "2023.08.26"
}
