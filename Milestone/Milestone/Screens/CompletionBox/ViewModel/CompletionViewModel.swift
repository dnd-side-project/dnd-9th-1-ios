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
    let style: WriteRetrospectStyle
    let contents: [String]
}

typealias CompletionSectionModel = AnimatableSectionModel<Int, Goal>

class CompletionViewModel: BindableViewModel {
    
    // MARK: BindableViewModel Properties
    var apiSession: APIService = APISession()
    
    var bag = DisposeBag()
    
    // MARK: Properties
    private var goalList = [
        Goal(title: "", startDate: Date(), endDate: Date(),isCompleted: true, identity: -1, style: .free, contents: []),
        Goal(title: "포토샵 자격증 따기", startDate: Date(), endDate: Date().addingTimeInterval(100), isCompleted: true, identity: 0, style: .free, contents: ["큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았다. 큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았큰 목표만 세큰 목표만 세웠을 때는 못큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았다. 큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았큰 목표만 세큰 목표만 세웠을 때는 못큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았다. 큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았큰 목표만 세큰 목표만 세웠을 때는 못"]),
        Goal(title: "자격증 포토샵 따기", startDate: Date().addingTimeInterval(100), endDate: Date().addingTimeInterval(200), isCompleted: true, identity: 1, style: .guide, contents: ["큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았다. 큰 목표만 세웠을 때는 못 이룰까봐 괜히 부담이 됐었는데, ‘작은 목표 하나라도 이루자’ 라는 마음으로 하니까 부담감도 많이 사라지고 포기도 안하게 돼서 좋았큰 목표만 세큰 목표만 세웠을 때는 못", "처음에는 쉽게 할 수 있을 줄 알았는데 막상 하다보니까 집중력도 많이 흐려지고, 생각보다 쓸 수 있는 시간이 적어서 기간 내에 해내는 것이 힘들었다.", "힘들어서 포기하고 싶었던 때도 있었지만, ‘2주 안에 작은 목표 하나만 끝내자’ 라는 마음을 가지려고 노력했다. 끈기를 배울 수 있었던 것 같다.", "내가 목표하는 회사에 지원할 때 강점이 될 어학 성적을 얻고자 했다."]),
        Goal(title: "스위프트 마스터하기", startDate: Date().addingTimeInterval(300), endDate: Date().addingTimeInterval(500), isCompleted: false, identity: 2, style: .guide, contents: [])]
    
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
