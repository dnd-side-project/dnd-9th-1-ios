//
//  StorageBoxViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/26.
//

import UIKit

import RxCocoa
import RxSwift

class StorageBoxViewModel: BindableViewModel {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Output
    
    var storedGoals = BehaviorRelay<[ParentGoal]>(value: [])
    var isSet = BehaviorRelay(value: false)
    
    var isLastPage: Bool = false
    var lastGoalId: Int = -1
    var isLoading = false
    
    /// 리스트 비우기
    func clearList() {
        isLastPage = false
        lastGoalId = -1
        storedGoals.accept([])
    }
    
    deinit {
        bag = DisposeBag()
    }
}

extension StorageBoxViewModel: ServicesGoalList {
    /// 보관함 목표 리스트 조회 API
    func retrieveStorageGoalList() {
        var storageGoalListResponse: Observable<Result<BaseModel<GoalResponse>, APIError>> {
            requestAllGoals(lastGoalId: lastGoalId, goalStatusParameter: .store)
        }
        isLoading = true
        
        storageGoalListResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    var newData: [ParentGoal] = storedGoals.value
                    newData.append(contentsOf: response.data.contents)
                    storedGoals.accept(newData)
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
}
