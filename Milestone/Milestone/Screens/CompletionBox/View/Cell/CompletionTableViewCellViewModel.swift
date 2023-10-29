//
//  CompletionTableViewCellViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/30.
//

import Foundation

import RxCocoa
import RxSwift

class CompletionTableViewCellViewModel {
    let title = BehaviorRelay<String>(value: "")
    let startDate = BehaviorRelay<String>(value: "")
    let endDate = BehaviorRelay<String>(value: "")
    let reward = BehaviorRelay<String>(value: "")
    let hasRetrospect = BehaviorRelay<Bool>(value: false)
    
    let upperGoalSelected = PublishSubject<UpperGoal>()
    let upperGoal: UpperGoal
    
    init(with upperGoal: UpperGoal) {
        self.upperGoal = upperGoal
        
        title.accept(upperGoal.title)
        startDate.accept(upperGoal.startDate)
        endDate.accept(upperGoal.endDate)
        reward.accept(upperGoal.reward ?? "")
        hasRetrospect.accept(upperGoal.hasRetrospect)
    }
}
