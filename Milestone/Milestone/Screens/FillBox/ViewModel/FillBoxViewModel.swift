//
//  FillBoxViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/22.
//

import UIKit

import RxCocoa
import RxSwift

class FillBoxViewModel: BindableViewModel, ServicesGoalList {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Output
    
    var goalCountByStatusResponse: Observable<Result<BaseModel<ParentGoalCount>, APIError>> {
        requestGoalCountByStatus()
    }
    var parentGoalListResponse: Observable<Result<BaseModel<GoalResponse>, APIError>> {
        requestAllGoals(goalStatusParameter: .process)
    }
    
    var goalCount = BehaviorRelay<Count>(value: Count(STORE: 0, PROCESS: 0, COMPLETE: 0))
    var progressGoals = BehaviorRelay<[ParentGoal]>(value: [])
    
    deinit {
        bag = DisposeBag()
    }
}

extension FillBoxViewModel {
    
    func retrieveGoalCountByStatus() {
        goalCountByStatusResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    goalCount.accept(response.data.counts)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    func retrieveParentGoalList() {
        parentGoalListResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    progressGoals.accept(response.data.contents)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
}
