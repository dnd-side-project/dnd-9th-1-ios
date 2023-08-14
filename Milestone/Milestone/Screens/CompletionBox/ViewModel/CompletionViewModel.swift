//
//  CompletionViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/14.
//

import Foundation
import RxSwift

struct Goal {
    let title: String
    let startDate: Date
    let endDate: Date
}

class CompletionViewModel {
    var goalList = Observable.just([Goal(title: "포토샵 자격증 따기", startDate: Date(), endDate: Date().addingTimeInterval(100)), Goal(title: "자격증 포토샵 따기", startDate: Date().addingTimeInterval(100), endDate: Date().addingTimeInterval(200)), Goal(title: "스위프트 마스터하기", startDate: Date().addingTimeInterval(300), endDate: Date().addingTimeInterval(500))])
}
