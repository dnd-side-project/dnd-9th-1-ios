//
//  ServicesGoalList.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import RxSwift

protocol ServicesGoalList: Service {
    
    func postReview(higherLevelGoalId: Int, retrospect: Retrospect) -> Observable<Result<BaseModel<Int>, APIError>>
    
    func requestRetrospect(goalId: Int) -> Observable<Result<BaseModel<Retrospect>, APIError>>
    
    func requestEnabledRetrospectCount() -> Observable<Result<BaseModel<RetrospectCount>, APIError>>

    func requestAllGoals(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse>, APIError>>
    
    func requestGoalCountByStatus() -> Observable<Result<BaseModel<ParentGoalCount>, APIError>>
    
    func requestPostParentGoal(reqBody: CreateParentGoal) -> Observable<Result<EmptyDataModel, APIError>>

}

extension ServicesGoalList {
    func requestAllGoals(goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse>, APIError>> {
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
    
    func requestGoalCountByStatus() -> Observable<Result<BaseModel<ParentGoalCount>, APIError>> {
        return apiSession.request(.requestGoalCountByStatus)
    }
    
    func requestPostParentGoal(reqBody: CreateParentGoal) -> Observable<Result<EmptyDataModel, APIError>> {
        return apiSession.request(.postGoal(goal: reqBody))
    }
}
