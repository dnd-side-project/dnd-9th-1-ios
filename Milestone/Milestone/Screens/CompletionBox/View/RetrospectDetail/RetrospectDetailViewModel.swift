//
//  RetrospectDetailViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/30.
//

import Foundation

import RxCocoa
import RxSwift

class RetrospectDetailViewModel: BindableViewModel, ViewModelType {

    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    let upperGoal: BehaviorRelay<UpperGoal>
    
    init(upperGoal: UpperGoal) {
        self.upperGoal = BehaviorRelay<UpperGoal>(value: upperGoal)
    }
    
    // TODO: - 마음 채움도 선택완료 여부까지 인풋으로 추가 필요
    struct Input {
        let likedTextViewChanged: Observable<String?>
        let lackedTextViewChanged: Observable<String?>
        let learnedTextViewChanged: Observable<String?>
        let longedForTextViewChanged: Observable<String?>
        let freeTextViewChanged: Observable<String?>
    }
    
    struct Output {
        let textViewCount: Driver<(Int?, Int?, Int?, Int?)>
        let freeTextViewCount: Driver<Int?>
        let guideViewButtonActivated: Driver<Bool>
        let freeViewButtonActivated: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let textViewCount = Observable.combineLatest(input.likedTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }, input.lackedTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }, input.learnedTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }, input.longedForTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }).asDriver(onErrorJustReturn: (0, 0, 0, 0))
        
        let guideViewActivated = textViewCount.map { $0.0 ?? 0 > 0 && $0.1 ?? 0 > 0 && $0.2 ?? 0 > 0 && $0.3 ?? 0 > 0 }
        
        let freeTextViewCount = input.freeTextViewChanged.map { $0 ?? "" != "자유롭게 회고를 작성해보세요!" ? $0?.count : 0 }.asDriver(onErrorJustReturn: 0)

        let freeViewActivated = freeTextViewCount.map { $0 ?? 0 > 0 }
        
        return Output(textViewCount: textViewCount, freeTextViewCount: freeTextViewCount, guideViewButtonActivated: guideViewActivated, freeViewButtonActivated: freeViewActivated)
    }
}
