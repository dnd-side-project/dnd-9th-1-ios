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
    
    // MARK: - Properties
    
    private var goalList = [
        Goal(identity: 0, title: "하이1", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이2", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이3", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이4", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이5", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이6", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이7", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이8", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이9", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이10", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이11", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true),
        Goal(identity: 0, title: "하이12", startDate: "2023.08.08", endDate: "2023.08.26", reminderEnabled: true)
    ]
    private lazy var store = BehaviorSubject<[Goal]>(value: goalList)
    
    var goalObservable: Observable<[Goal]> {
        return store
    }
    
    deinit {
        bag = DisposeBag()
    }
}
