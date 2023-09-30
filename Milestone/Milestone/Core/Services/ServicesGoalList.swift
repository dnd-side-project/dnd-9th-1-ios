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
    
    func requestEnabledRetrospectCount() -> Single<BaseModel<RetrospectCount>>

    func requestAllGoals(lastGoalId: Int, goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse>, APIError>>
    
    func requestGoalCountByStatus() -> Observable<Result<BaseModel<UpperGoalCount>, APIError>>
    
    func requestPostUpperGoal(reqBody: CreateUpperGoal) -> Observable<Result<EmptyDataModel, APIError>>

    func requestModifyUpperGoal(id: Int, reqBody: Goal) -> Observable<Result<BaseModel<UpperGoalInfo>, APIError>>
    
    func requestDeleteUpperGoal(id: Int) -> Observable<Result<EmptyDataModel, APIError>>
    
    func requestRestoreUpperGoal(id: Int, reqBody: Goal) -> Observable<Result<EmptyDataModel, APIError>>
    
    func requestRecommendGoal() -> Observable<Result<BaseModel<[UpperGoal]>, APIError>>
     
}

extension ServicesGoalList {
    func requestAllGoals(lastGoalId: Int, goalStatusParameter: GoalStatusParameter) -> Observable<Result<BaseModel<GoalResponse>, APIError>> {
        return apiSession.request(.requestAllGoals(lastGoalId: lastGoalId, goalStatus: goalStatusParameter))
    }
    
    func postReview(higherLevelGoalId: Int, retrospect: Retrospect) -> Observable<Result<BaseModel<Int>, APIError>> {
        return apiSession.request(.postRetrospect(higherLevelGoalId: higherLevelGoalId, retrospect: retrospect))
    }
    
    func requestRetrospect(goalId: Int) -> Observable<Result<BaseModel<Retrospect>, APIError>> {
        return apiSession.request(.requestRetrospect(higherLevelGoalId: goalId))
    }
    
    func requestEnabledRetrospectCount() -> Single<BaseModel<RetrospectCount>> {
        return apiSession.requestSingle(.requestEnabledRetrospectCount)
    }
    
    func requestGoalCountByStatus() -> Observable<Result<BaseModel<UpperGoalCount>, APIError>> {
        return apiSession.request(.requestGoalCountByStatus)
    }
    
    func requestPostUpperGoal(reqBody: CreateUpperGoal) -> Observable<Result<EmptyDataModel, APIError>> {
        return apiSession.request(.postGoal(goal: reqBody))
    }
    
    // 상위 목표 수정
    func requestModifyUpperGoal(id: Int, reqBody: Goal) -> Observable<Result<BaseModel<UpperGoalInfo>, APIError>> {
        return apiSession.request(.editGoal(id: id, goal: reqBody))
    }
    
    // 상위 목표 삭제
    func requestDeleteUpperGoal(id: Int) -> Observable<Result<EmptyDataModel, APIError>> {
        return apiSession.request(.deleteGoal(id: id))
    }
    
    // 상위 목표 복구
    func requestRestoreUpperGoal(id: Int, reqBody: Goal) -> Observable<Result<EmptyDataModel, APIError>> {
        return apiSession.request(.recoverGoal(id: id, goal: reqBody))
    }
    
    // 보관함에 있는 상위 목표 추천
    func requestRecommendGoal() -> Observable<Result<BaseModel<[UpperGoal]>, APIError>> {
        return apiSession.request(.requestRecommendGoal)
    }
}
