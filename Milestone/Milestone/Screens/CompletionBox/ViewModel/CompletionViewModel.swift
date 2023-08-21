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

typealias CompletionSectionModel = AnimatableSectionModel<Int, Goal>

class CompletionViewModel: BindableViewModel {
    
    // MARK: BindableViewModel Properties
    var apiSession: APIService = APISession()
    
    var bag = DisposeBag()
    
    // MARK: Properties
    private var goalList = [Goal(identity: 0, title: "", startDate: "", endDate: "", reminderEnabled: true)]
    
    //    private var goalList: [Goal] = []
    
    private lazy var sectionModel = goalList.enumerated().map { index, goal in
        CompletionSectionModel(model: index, items: [goal])
    }
    
    private lazy var store = BehaviorSubject<[CompletionSectionModel]>(value: sectionModel)
    
    var completionList: Observable<[CompletionSectionModel]> {
        return store
    }
    
    var goalObservable: Observable<Goal> {
        return Observable.from(goalList)
    }
    
    deinit {
        bag = DisposeBag()
    }
}
