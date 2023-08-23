//
//  CompletionViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/14.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

class CompletionViewModel: BindableViewModel {
    
    // MARK: BindableViewModel Properties
    var apiSession: APIService = APISession()
    
    var bag = DisposeBag()
    
    // MARK: - Output
    var goalResponse: Observable<Result<BaseModel<GoalResponse<CompletedGoal>>, APIError>> {
        requestAllGoals(goalStatusParameter: .complete)
    }
    
    var goalData = BehaviorRelay<[CompletedGoal]>(value: [])
    var goalDataCount = PublishRelay<Int>()
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    deinit {
        bag = DisposeBag()
    }
}

extension CompletionViewModel: ServicesGoalList {
    func retrieveGoalData() {
        isLoading.accept(true)
        goalResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    self.goalData.accept(response.data.contents)
                    self.goalDataCount.accept(response.data.contents.count)
                    self.isLoading.accept(false)
                case .failure(let error):
                    print(error)
                    self.isLoading.accept(false)
                }
            })
            .disposed(by: bag)
    }
    
    func retrieveGoalDataAtIndex(index: Int) -> Observable<CompletedGoal> {
        return goalData.map { $0[index] }
    }
}
