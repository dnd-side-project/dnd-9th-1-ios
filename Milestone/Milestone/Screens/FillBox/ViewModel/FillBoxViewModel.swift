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
    
    var goalResponse: Observable<Result<BaseModel<GoalResponse>, APIError>> {
        requestAllGoals(goalStatusParameter: .process)
    }
    var progressGoals = BehaviorRelay<[ParentGoal]>(value: [])
    
    deinit {
        bag = DisposeBag()
    }
}

extension FillBoxViewModel: ServicesGoalList {
    func retrieveGoalData() {
        goalResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    progressGoals.accept(response.data.contents)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
    }
}
