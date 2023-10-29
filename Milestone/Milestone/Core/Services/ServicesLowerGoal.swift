//
//  ServicesLowerGoal.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import Foundation

import RxSwift

// MARK: - 하위 목표와 관련된 서비스 함수 작성

protocol ServicesLowerGoal: Service {
    /// 하위 목표 리스트 조회 API 요청
    func requestLowerGoalList(id: Int) -> Observable<Result<BaseModel<[LowerGoal]>, APIError>>
    /// 하위 목표 생성 API 요청
    func requestPostLowerGoal(id: Int, reqBody: NewLowerGoal) -> Observable<Result<BaseModel<Int>, APIError>>
    /// 하위 목표 완료 API 요청
    func requestCompleteLowerGoal(id: Int) -> Observable<Result<BaseModel<StateUpdatedUpperGoal>, APIError>>
    /// 하위 목표 완료 취소 API 요청
    func requestIncompleteLowerGoal(id: Int) -> Observable<Result<EmptyDataModel, APIError>>
    /// 하위 목표 상세 정보 API 요청
    func requestLowerGoalInfo(id: Int) -> Observable<Result<BaseModel<LowerGoalInfo>, APIError>>
    /// 하위 목표 수정 API 요청
    func requestEditLowerGoal(id: Int, reqBody: NewLowerGoal) -> Observable<Result<BaseModel<Int>, APIError>>
    /// 하위 목표 삭제 API 요청
    func requestDeleteLowerGoal(id: Int) -> Observable<Result<BaseModel<StateUpdatedUpperGoal>, APIError>>
}

extension ServicesLowerGoal {
    func requestLowerGoalList(id: Int) -> Observable<Result<BaseModel<[LowerGoal]>, APIError>> {
        return apiSession.request(.requestAllLowerGoal(upperGoalId: id))
    }
    func requestPostLowerGoal(id: Int, reqBody: NewLowerGoal) -> Observable<Result<BaseModel<Int>, APIError>> {
        return apiSession.request(.postLowerGoal(upperGoalId: id, lowerGoal: reqBody))
    }
    func requestCompleteLowerGoal(id: Int) -> Observable<Result<BaseModel<StateUpdatedUpperGoal>, APIError>> {
        return apiSession.request(.completeLowerGoal(lowerGoalId: id))
    }
    func requestIncompleteLowerGoal(id: Int) -> Observable<Result<EmptyDataModel, APIError>> {
        return apiSession.request(.incompleteLowerGoal(lowerGoalId: id))
    }
    func requestLowerGoalInfo(id: Int) -> Observable<Result<BaseModel<LowerGoalInfo>, APIError>> {
        return apiSession.request(.requestLowerGoalInformation(lowerGoalId: id))
    }
    func requestEditLowerGoal(id: Int, reqBody: NewLowerGoal) -> Observable<Result<BaseModel<Int>, APIError>> {
        return apiSession.request(.editLowerGoal(lowerGoalId: id, lowerGoal: reqBody))
    }
    func requestDeleteLowerGoal(id: Int) -> Observable<Result<BaseModel<StateUpdatedUpperGoal>, APIError>> {
        return apiSession.request(.deleteLowerGoal(lowerGoalId: id))
    }
}
