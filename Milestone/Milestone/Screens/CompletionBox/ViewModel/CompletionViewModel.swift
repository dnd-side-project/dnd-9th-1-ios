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

struct Goal: IdentifiableType, Equatable {
    let title: String
    let startDate: Date
    let endDate: Date
    let isCompleted: Bool
    let identity: Int
}

typealias CompletionSectionModel = AnimatableSectionModel<Int, Goal>

class CompletionViewModel {
    
    private var goalList = [Goal(title: "", startDate: Date(), endDate: Date(),isCompleted: true, identity: -1), Goal(title: "포토샵 자격증 따기", startDate: Date(), endDate: Date().addingTimeInterval(100), isCompleted: true, identity: 0), Goal(title: "자격증 포토샵 따기", startDate: Date().addingTimeInterval(100), endDate: Date().addingTimeInterval(200), isCompleted: true, identity: 1), Goal(title: "스위프트 마스터하기", startDate: Date().addingTimeInterval(300), endDate: Date().addingTimeInterval(500), isCompleted: false, identity: 2)]
    
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
}
