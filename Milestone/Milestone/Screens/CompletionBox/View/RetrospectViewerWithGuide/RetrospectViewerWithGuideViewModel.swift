//
//  RetrospectViewerWithGuideViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/10/01.
//

import Foundation

import RxCocoa
import RxSwift

class RetrospectViewerWithGuideViewModel {
    
    let retrospect: BehaviorRelay<Retrospect>
    let upperGoal: BehaviorRelay<UpperGoal>
    
    init(retrospect: Retrospect, upperGoal: UpperGoal) {
        self.retrospect = BehaviorRelay<Retrospect>(value: retrospect)
        self.upperGoal = BehaviorRelay<UpperGoal>(value: upperGoal)
    }
}
