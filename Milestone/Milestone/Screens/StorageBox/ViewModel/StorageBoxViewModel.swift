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
    
    deinit {
        bag = DisposeBag()
    }
}

extension StorageBoxViewModel: ServicesGoalList {
    /// 보관함 목표 리스트 조회 API
    func retrieveStorageGoalList() {
        var storageGoalListResponse: Observable<Result<BaseModel<GoalResponse>, APIError>> {
            requestAllGoals(goalStatusParameter: .store)
        }
        storageGoalListResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    storedGoals.accept(response.data.contents)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
}
