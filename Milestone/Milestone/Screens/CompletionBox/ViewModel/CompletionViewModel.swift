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

class CompletionViewModel: BindableViewModel, ViewModelType {
    
    // MARK: BindableViewModel Properties
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    var lastPageId = -1
    var isLastPage = false
    var isLoading = false
    
    struct Input {
        let viewDidAppear: Observable<Void>
        let selection: Driver<CompletionTableViewCellViewModel>
        let retrieveNextPageTrigger: Observable<Void>
    }
    
    struct Output {
        let retrospectCount: BehaviorRelay<Int>
        let isAlertBoxHidden: BehaviorRelay<Bool>
        let items: BehaviorRelay<[CompletionTableViewCellViewModel]>
        let retrospectSelected: Driver<RetrospectDetailViewModel>
    }
    
    func transform(input: Input) -> Output {
        let count = BehaviorRelay(value: 0)
        let alertBoxHidden = BehaviorRelay(value: false)
        let items = BehaviorRelay<[CompletionTableViewCellViewModel]>(value: [])
        
        input.viewDidAppear
            .flatMapLatest { [unowned self] () -> Observable<BaseModel<RetrospectCount>> in
                return self.requestEnabledRetrospectCount().asObservable()
            }
            .subscribe(onNext: {
                count.accept($0.data.count)
            })
            .disposed(by: bag)
        
        input.retrieveNextPageTrigger
            .flatMapLatest { [unowned self] () -> Observable<BaseModel<GoalResponse>> in
                self.isLoading = true
                return self.requestAllGoalsWithSignle(lastGoalId: self.lastPageId, goalStatusParameter: .complete).asObservable()
            }
            .map { [unowned self] in
                self.lastPageId = $0.data.contents.last?.goalId ?? -1
                self.isLastPage = !$0.data.next

                return $0.data.contents
                    .map {
                        let viewModel = CompletionTableViewCellViewModel(with: $0)
                        return viewModel
                    }
            }
            .subscribe(onNext: { [unowned self] in
                items.accept(items.value + $0)
                self.isLoading = false
            })
            .disposed(by: bag)
        
        input.viewDidAppear
            .flatMapLatest { [unowned self] () -> Observable<BaseModel<GoalResponse>> in
                return self.requestAllGoalsWithSignle(lastGoalId: -1, goalStatusParameter: .complete).asObservable()
            }
            .map { [unowned self] in
                self.lastPageId = $0.data.contents.last?.goalId ?? -1
                self.isLastPage = !$0.data.next
                
                alertBoxHidden.accept($0.data.contents.isEmpty)
                return $0.data.contents
                    .map {
                        let viewModel = CompletionTableViewCellViewModel(with: $0)
                        return viewModel
                    }
            }
            .subscribe(onNext: {
                items.accept($0)
            })
            .disposed(by: bag)
        
        // MARK: - 푸시할 뷰 분기처리
        let retrospectSelected = input.selection.map { cell -> RetrospectDetailViewModel in
            let vm = RetrospectDetailViewModel(upperGoal: cell.upperGoal)
            return vm
        }
        
        return Output(retrospectCount: count, isAlertBoxHidden: alertBoxHidden, items: items, retrospectSelected: retrospectSelected)
    }
    
    func retrieveRetrospect(goalId: Int) -> Single<BaseModel<Retrospect>> {
        requestRetrospectWithSingle(goalId: goalId)
    }
    
    enum FetchState {
        case fetching
        case idle
    }
    
    // MARK: - Output
    var goalResponse: Observable<Result<BaseModel<GoalResponse>, APIError>> {
        requestAllGoals(lastGoalId: -1, goalStatusParameter: .complete)
    }
    
    var authTestResponse: Observable<Result<String, APIError>> {
        authTest()
    }
    
    var goalData = BehaviorRelay<[UpperGoal]>(value: [])

    var goalDataCount = PublishRelay<Int>()
    var enabledRetrospectCount = BehaviorRelay<Int>(value: 0)
    let isTableviewUpdated = BehaviorRelay<Bool>(value: false)
    
//    var isLoading = BehaviorRelay<Bool>(value: false)
    var presentModal = BehaviorRelay<Bool>(value: false)
    
    let retrospect = PublishRelay<Retrospect>()
    
    deinit {
        bag = DisposeBag()
    }
}

/// output
extension CompletionViewModel: ServicesGoalList, ServicesUser { }

//extension CompletionViewModel {
//    func retrieveGoalData() {
//        isLoading.accept(true)
//
//        goalResponse
//            .subscribe(onNext: { [unowned self] result in
//                switch result {
//                case .success(let response):
//                    self.goalData.accept(response.data.contents)
//                    self.goalDataCount.accept(response.data.contents.count)
//                    self.lastPageId = response.data.contents.last?.goalId ?? -1
//                    self.isLoading.accept(false)
//                    self.isTableviewUpdated.accept(true)
//                case .failure(let error):
//                    print(error)
//                    self.isLoading.accept(false)
//                }
//            })
//            .disposed(by: bag)
//    }
//
//    func retrieveGoalDataAtIndex(index: Int) -> UpperGoal {
//        return goalData.value[index]
//    }
//
//    func retrieveRetrospectWithId(goalId: Int) {
//        requestRetrospect(goalId: goalId)
//            .subscribe(onNext: { [unowned self] result in
//                switch result {
//                case .success(let response):
//                    self.retrospect.accept(response.data)
//                case .failure(let error):
//                    print(error)
//                }
//            })
//            .disposed(by: bag)
//    }
//
//    /// 로딩 & lastPage 관련 로직도 추가 필요
//    func retrieveMoreRetrospect() {
//        isLoading.accept(true)
//        requestAllGoals(lastGoalId: lastPageId, goalStatusParameter: .complete)
//            .subscribe(onNext: { [unowned self] result in
//                switch result {
//                case .success(let response):
//                    self.isLoading.accept(false)
//                    var newData = self.goalData.value
//                    newData.append(contentsOf: response.data.contents)
//                    self.goalData.accept(newData)
//                    self.isLastPage = !response.data.next
//                    if !isLastPage {
//                        self.lastPageId = response.data.contents.last?.goalId ?? -1
//                    }
//                case .failure:
//                    self.isLoading.accept(false)
//                }
//            })
//            .disposed(by: bag)
//    }
//}
//
///// input
//extension CompletionViewModel {
//
//    @discardableResult
//    func saveRetrospect(goalId: Int, retrospect: Retrospect) -> Observable<Result<BaseModel<Int>, APIError>> {
//        return postReview(higherLevelGoalId: goalId, retrospect: retrospect)
//    }
//
//    func handlingPostResponse(result: Result<BaseModel<Int>, APIError>) {
//        switch result {
//        case .success:
//            isLoading.accept(false)
//            self.presentModal.accept(true)
//        case .failure(let error):
//            isLoading.accept(false)
//            print(error)
//        }
//    }
//}
