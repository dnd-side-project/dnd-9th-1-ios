//
//  RetrospectDetailViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/30.
//

import Foundation

import RxCocoa
import RxSwift

class RetrospectDetailViewModel: ViewModelType {
    
    let upperGoal: BehaviorRelay<UpperGoal>
    
    init(upperGoal: UpperGoal) {
        self.upperGoal = BehaviorRelay<UpperGoal>(value: upperGoal)
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
