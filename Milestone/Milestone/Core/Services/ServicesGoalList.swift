//
//  ServicesGoalList.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import RxSwift

protocol ServicesGoalList: Service {
    func requestAllGoals(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse>, APIError>>
    func requestGoalCountByStatus() -> Observable<Result<BaseModel<ParentGoalCount>, APIError>>
}

extension ServicesGoalList {
    func requestAllGoals(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse>, APIError>> {
        return apiSession.request(.requestAllGoals(goalStatus: goalStatusParameter))
    }
    func requestGoalCountByStatus() -> Observable<Result<BaseModel<ParentGoalCount>, APIError>> {
        return apiSession.request(.requestGoalCountByStatus)
    }
}
