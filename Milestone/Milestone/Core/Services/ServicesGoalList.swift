//
//  ServicesGoalList.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import RxSwift

protocol ServicesGoalList: Service {
    func requestAllGoals() -> Observable<Result<BaseModel<[Goal]>, APIError>>
}

extension ServicesGoalList {
    func requestAllGoals(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<[Goal]>, APIError>> {
        return apiSession.request(.requestAllGoals(goalStatus: goalStatusParameter))
    }
}
