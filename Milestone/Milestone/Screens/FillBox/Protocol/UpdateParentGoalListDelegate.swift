//
//  UpdateParentGoalListDelegate.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import Foundation

/// 채움함이 아닌 다른 뷰에서 상위 목표 리스트를 업데이트 할 때 사용
protocol UpdateParentGoalListDelegate: AnyObject {
    func updateParentGoalList()
}
