//
//  UpdateUpperGoalListDelegate.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import Foundation

/// 채움함이 아닌 다른 뷰에서 상위 목표 리스트를 업데이트 할 때 사용
protocol UpdateUpperGoalListDelegate: AnyObject {
    func updateUpperGoalList()
}

/// 채움함이 아닌 다른 뷰에서 하위 목표 리스트를 업데이트 할 때 사용
protocol UpdateLowerGoalListDelegate: AnyObject {
    func updateLowerGoalList()
}

