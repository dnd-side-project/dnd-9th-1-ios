//
//  ServicesGoalList.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import RxSwift

protocol ServicesGoalList: Service {
    func requestAllGoals<T>(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse<T>>, APIError>>
}

extension ServicesGoalList {
    func requestAllGoals<T>(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse<T>>, APIError>> {
        return apiSession.request(.requestAllGoals(goalStatus: goalStatusParameter))
    }
}
