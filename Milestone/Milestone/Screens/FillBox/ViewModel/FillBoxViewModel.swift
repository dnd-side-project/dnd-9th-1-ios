//
//  FillBoxViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/22.
//

import UIKit

import RxCocoa
import RxSwift

class FillBoxViewModel: BindableViewModel {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Output
    
    var progressGoalCount = BehaviorRelay<String>(value: "0")
    var completedGoalCount = BehaviorRelay<String>(value: "0")
    var storedGoalCount = BehaviorRelay<String>(value: "0")
    var progressGoals = BehaviorRelay<[UpperGoal]>(value: [])
    var recommendedGoals = BehaviorRelay<[UpperGoal]>(value: [])
    
    var isLastPage: Bool = false
    var lastGoalId: Int = -1
    var isLoading = false
    var isSet = BehaviorRelay(value: false)

    deinit {
        bag = DisposeBag()
    }
}

extension FillBoxViewModel: ServicesGoalList {
    /// 상위 목표 상태별 개수 조회
    func retrieveGoalCountByStatus() {
        var goalCountByStatusResponse: Observable<Result<BaseModel<UpperGoalCount>, APIError>> {
            requestGoalCountByStatus()
        }
        goalCountByStatusResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    progressGoalCount.accept(String(response.data.counts.PROCESS))
                    completedGoalCount.accept(String(response.data.counts.COMPLETE))
                    storedGoalCount.accept(String(response.data.counts.STORE))
                    
                    self.retrieveUpperGoalList()
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 상위 목표 리스트 조회
    func retrieveUpperGoalList() {
        var upperGoalListResponse: Observable<Result<BaseModel<GoalResponse>, APIError>> {
            requestAllGoals(lastGoalId: lastGoalId, goalStatusParameter: .process)
        }
        isLoading = true
        
        upperGoalListResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    var newData: [UpperGoal] = progressGoals.value
                    newData.append(contentsOf: response.data.contents)
                    progressGoals.accept(newData)
                    isSet.accept(true)
                    isLastPage = !response.data.next
                    if !isLastPage {
                        lastGoalId = newData.last?.goalId ?? -1
                    }
                    isLoading = false
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 리스트 비우기
    func clearList() {
        isLastPage = false
        lastGoalId = -1
        progressGoals.accept([])
    }
    
    /// 보관함에 있는 상위 목표 랜덤 3개 조회
    func retrieveRecommendGoal() {
        var recommendGoalResponse: Observable<Result<BaseModel<[UpperGoal]>, APIError>> {
            requestRecommendGoal()
        }
        
        recommendGoalResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    recommendedGoals.accept(response.data)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
}
