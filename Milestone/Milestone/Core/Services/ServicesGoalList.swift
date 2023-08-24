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
    
    func postReview(higherLevelGoalId: Int, retrospect: Retrospect) -> Observable<Result<BaseModel<Int>, APIError>>
    
    func requestRetrospect(goalId: Int) -> Observable<Result<BaseModel<Retrospect>, APIError>>
    
    func requestEnabledRetrospectCount() -> Observable<Result<BaseModel<RetrospectCount>, APIError>>
}

extension ServicesGoalList {
    func requestAllGoals<T>(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse<T>>, APIError>> {
        return apiSession.request(.requestAllGoals(goalStatus: goalStatusParameter))
    }
    
    func postReview(higherLevelGoalId: Int, retrospect: Retrospect) -> Observable<Result<BaseModel<Int>, APIError>> {
        return apiSession.request(.postRetrospect(higherLevelGoalId: higherLevelGoalId, retrospect: retrospect))
    }
    
    func requestRetrospect(goalId: Int) -> Observable<Result<BaseModel<Retrospect>, APIError>> {
        return apiSession.request(.requestRetrospect(higherLevelGoalId: goalId))
    }
    
    func requestEnabledRetrospectCount() -> Observable<Result<BaseModel<RetrospectCount>, APIError>> {
        return apiSession.request(.requestEnabledRetrospectCount)
    }
}
