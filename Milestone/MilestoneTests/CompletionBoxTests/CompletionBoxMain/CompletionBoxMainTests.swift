//
//  CompletionBoxMainTests.swift
//  MilestoneTests
//
//  Created by 박경준 on 2023/10/20.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Milestone

final class CompletionBoxMainTests: XCTestCase {
    
    var viewModel: CompletionViewModel!
    var output: CompletionViewModel.Output!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    var viewDidAppearSubject: PublishSubject<Void>!
    var selectionSubject: PublishSubject<CompletionTableViewCellViewModel>!
    var retrieveNextPageSubject: PublishSubject<Void>!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        let upperGoal = UpperGoal(goalId: 0, title: "", startDate: "", endDate: "", entireDetailGoalCnt: 0, completedDetailGoalCnt: 0, dDay: 0, hasRetrospect: true, reminderEnabled: true, reward: nil)
        
        viewDidAppearSubject = PublishSubject<Void>()
        selectionSubject = PublishSubject<CompletionTableViewCellViewModel>()
        retrieveNextPageSubject = PublishSubject<Void>()
        
        viewModel = CompletionViewModel()
        
        output = viewModel.transform(input: CompletionViewModel.Input(viewDidAppear: viewDidAppearSubject.asObservable(), selection: selectionSubject.asDriver(onErrorJustReturn: CompletionTableViewCellViewModel(with: upperGoal)), retrieveNextPageTrigger: retrieveNextPageSubject))
    }

    override func tearDownWithError() throws {
    }
    
    func testCompletion() {
        /// Given
        /// 1. viewDidAppear 트리거
        
        scheduler.createColdObservable([
            .next(0, ())
        ]).bind(to: viewDidAppearSubject).disposed(by: disposeBag)
        
        /// When
        /// 1. API 요청
        
    }
}
