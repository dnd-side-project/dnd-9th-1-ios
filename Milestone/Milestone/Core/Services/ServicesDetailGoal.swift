//
//  ServicesDetailGoal.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import Foundation

import RxSwift

// MARK: - 세부 목표와 관련된 서비스 함수 작성

protocol ServicesDetailGoal: Service {
    // 세부 목표 리스트 조회 API 요청
    func requestDetailGoalList(id: Int) -> Observable<Result<BaseModel<[DetailGoal]>, APIError>>
    // 세부 목표 생성 API 요청
    func requestPostDetailGoal(id: Int, reqBody: DetailGoalInfo) -> Observable<Result<EmptyDataModel, APIError>>
}

extension ServicesDetailGoal {
    func requestDetailGoalList(id: Int) -> Observable<Result<BaseModel<[DetailGoal]>, APIError>> {
        return apiSession.request(.requestAllDetailGoal(higherLevelGoalId: id))
    }
    func requestPostDetailGoal(id: Int, reqBody: DetailGoalInfo) -> Observable<Result<EmptyDataModel, APIError>> {
        return apiSession.request(.postDetailGoal(higherLevelGoalId: id, detailGoal: reqBody))
    }
}
