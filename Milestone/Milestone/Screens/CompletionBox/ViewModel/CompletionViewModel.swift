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
    
    var enabledRetrospectCountResponse: Observable<Result<BaseModel<RetrospectCount>, APIError>> {
        requestEnabledRetrospectCount()
    }
    
    var goalData = BehaviorRelay<[CompletedGoal]>(value: [])
    var goalDataCount = PublishRelay<Int>()
    var enabledRetrospectCount = BehaviorRelay<Int>(value: 0)
    let isTableviewUpdated = BehaviorRelay<Bool>(value: false)
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var presentModal = BehaviorRelay<Bool>(value: false)
    
    let retrospect = PublishRelay<Retrospect>()
    
    deinit {
        bag = DisposeBag()
    }
}

/// output
extension CompletionViewModel: ServicesGoalList { }

extension CompletionViewModel {
    func retrieveGoalData() {
        isLoading.accept(true)
        goalResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    self.goalData.accept(response.data.contents)
                    self.goalDataCount.accept(response.data.contents.count)
                    self.isLoading.accept(false)
                    self.isTableviewUpdated.accept(true)
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
    
    func retrieveRetrospectWithId(goalId: Int) {
        requestRetrospect(goalId: goalId)
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    self.retrospect.accept(response.data)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
    }
    
    func retrieveRetrospectCount() {
        enabledRetrospectCountResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let countResponse):
                    enabledRetrospectCount.accept(countResponse.data.count)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
    }
}

/// input
extension CompletionViewModel {

    @discardableResult
    func saveRetrospect(goalId: Int, retrospect: Retrospect) -> Observable<Result<BaseModel<Int>, APIError>> {
        return postReview(higherLevelGoalId: goalId, retrospect: retrospect)
    }
    
    func handlingPostResponse(result: Observable<Result<BaseModel<Int>, APIError>>) {
        isLoading.accept(true)
        result.subscribe(onNext: { [unowned self] response in
            switch response {
            case .success:
                isLoading.accept(false)
                self.presentModal.accept(true)
            case .failure(let error):
                isLoading.accept(false)
                print(error)
            }
        })
        .disposed(by: bag)
    }
}
