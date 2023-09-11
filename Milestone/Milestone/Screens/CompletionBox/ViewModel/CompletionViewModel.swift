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
    var goalResponse: Observable<Result<BaseModel<GoalResponse>, APIError>> {
        requestAllGoals(lastGoalId: -1, goalStatusParameter: .complete)
    }
    
    var enabledRetrospectCountResponse: Observable<Result<BaseModel<RetrospectCount>, APIError>> {
        requestEnabledRetrospectCount()
    }
    
    // FIXME: - 테스트코드
    var authTestResponse: Observable<Result<String, APIError>> {
        authTest()
    }
    
    var goalData = BehaviorRelay<[ParentGoal]>(value: [])

    var goalDataCount = PublishRelay<Int>()
    var enabledRetrospectCount = BehaviorRelay<Int>(value: 0)
    let isTableviewUpdated = BehaviorRelay<Bool>(value: false)
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var presentModal = BehaviorRelay<Bool>(value: false)
    
    let retrospect = PublishRelay<Retrospect>()
    var lastPageId = -1
    var isLastPage = false
    
    deinit {
        bag = DisposeBag()
    }
}

/// output
extension CompletionViewModel: ServicesGoalList, ServicesUser { }

extension CompletionViewModel {
    func retrieveGoalData() {
        isLoading.accept(true)
        goalResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    self.goalData.accept(response.data.contents)
                    self.goalDataCount.accept(response.data.contents.count)
                    self.lastPageId = response.data.contents.last?.goalId ?? -1
                    self.isLoading.accept(false)
                    self.isTableviewUpdated.accept(true)
                case .failure(let error):
                    print(error)
                    self.isLoading.accept(false)
                }
            })
            .disposed(by: bag)
    }
    
    func retrieveGoalDataAtIndex(index: Int) -> ParentGoal {
        return goalData.value[index]
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
    
    /// 로딩 & lastPage 관련 로직도 추가 필요
    func retrieveMoreRetrospect() {
        isLoading.accept(true)
        requestAllGoals(lastGoalId: lastPageId, goalStatusParameter: .complete)
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    self.isLoading.accept(false)
                    var newData = self.goalData.value
                    newData.append(contentsOf: response.data.contents)
                    self.goalData.accept(newData)
                    self.isLastPage = !response.data.next
                    if !isLastPage {
                        self.lastPageId = response.data.contents.last?.goalId ?? -1
                    }
                case .failure:
                    self.isLoading.accept(false)
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
    
    func handlingPostResponse(result: Result<BaseModel<Int>, APIError>) {
        switch result {
        case .success:
            isLoading.accept(false)
            self.presentModal.accept(true)
        case .failure(let error):
            isLoading.accept(false)
            print(error)
        }
    }
}
