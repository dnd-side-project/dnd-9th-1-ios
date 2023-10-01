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
    
    struct Input {
        // 텍스트뷰 입력
        let likedTextViewChanged: Observable<String?>
        let lackedTextViewChanged: Observable<String?>
        let learnedTextViewChanged: Observable<String?>
        let longedForTextViewChanged: Observable<String?>
        let freeTextViewChanged: Observable<String?>
        
        // 마음채움도 입력
        let pointSelectedWithGuide: Observable<FillPoint>
        let pointSelectedWithoutGuide: Observable<FillPoint>
        
        // 저장버튼 탭
        let saveButtonTriggerWithGuide: Observable<Void>
        let saveButtonTriggerWithoutGuide: Observable<Void>
    }
    
    struct Output {
        let textViewCount: Driver<(Int?, Int?, Int?, Int?)>
        let freeTextViewCount: Driver<Int?>
        let guideViewButtonActivated: Driver<Bool>
        let freeViewButtonActivated: Driver<Bool>
        
        let modalPresent: Observable<BaseModel<Int>>
    }
    
    func transform(input: Input) -> Output {
        
        let textViewCount = Observable.combineLatest(input.likedTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }, input.lackedTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }, input.learnedTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }, input.longedForTextViewChanged.map { $0 ?? "" != "내용을 입력해주세요!" ? $0?.count : 0 }).asDriver(onErrorJustReturn: (0, 0, 0, 0))
        
        let guideViewActivated = input.pointSelectedWithGuide
            .flatMapLatest { _ in
                textViewCount.map { $0.0 ?? 0 > 0 && $0.1 ?? 0 > 0 && $0.2 ?? 0 > 0 && $0.3 ?? 0 > 0 }
            }
            .asDriver(onErrorJustReturn: false)
        
        let freeTextViewCount = input.freeTextViewChanged.map { $0 ?? "" != "자유롭게 회고를 작성해보세요!" ? $0?.count : 0 }.asDriver(onErrorJustReturn: 0)

        let freeViewActivated = input.pointSelectedWithoutGuide
            .flatMapLatest { _ in
                freeTextViewCount.map { $0 ?? 0 > 0 }
            }
            .asDriver(onErrorJustReturn: false)
        
        let saveWithGuide = input.saveButtonTriggerWithGuide
            .flatMapLatest {
                Observable.combineLatest(input.pointSelectedWithGuide, input.likedTextViewChanged, input.lackedTextViewChanged, input.learnedTextViewChanged, input.longedForTextViewChanged)
            }
            .flatMapLatest { [unowned self] (selectPoint, liked, lacked, learned, longedFor) -> Observable<BaseModel<Int>> in
                
                let retrospect = Retrospect(hasGuide: true, contents: ["LIKED": liked ?? "", "LACKED": lacked ?? "", "LEARNED": learned ?? "", "LONGED_FOR": longedFor ?? ""], successLevel: selectPoint.rawValue)
                return self.postRetrospectSingle(higherLevelGoalId: self.upperGoal.value.goalId, retrospect: retrospect).asObservable()
            }
        
        let saveWithoutGuide = Observable.combineLatest(input.saveButtonTriggerWithoutGuide, Observable.combineLatest(input.pointSelectedWithoutGuide, input.freeTextViewChanged))
            .flatMapLatest { [unowned self] (_, arg1) -> Observable<BaseModel<Int>> in
                let (fillPoint, text) = arg1
                let retrospect = Retrospect(hasGuide: false, contents: ["NONE": text ?? ""], successLevel: fillPoint.rawValue)
                return self.postRetrospectSingle(higherLevelGoalId: self.upperGoal.value.goalId, retrospect: retrospect).asObservable()
            }
        
        input.saveButtonTriggerWithoutGuide
            .flatMapLatest {
                Observable.combineLatest(input.pointSelectedWithoutGuide, input.freeTextViewChanged)
            }
            .flatMapLatest { [unowned self] (fillPoint, text) -> Observable<BaseModel<Int>> in
                let retrospect = Retrospect(hasGuide: false, contents: ["NONE": text ?? ""], successLevel: fillPoint.rawValue)
                return self.postRetrospectSingle(higherLevelGoalId: self.upperGoal.value.goalId, retrospect: retrospect).asObservable()
            }
        
        let modalPresent = Observable.of(saveWithGuide, saveWithoutGuide)
            .merge()
        
        // MARK: - Retrospect 객체 생성
        
        return Output(textViewCount: textViewCount, freeTextViewCount: freeTextViewCount, guideViewButtonActivated: guideViewActivated, freeViewButtonActivated: freeViewActivated, modalPresent: modalPresent)
    }
}

extension RetrospectDetailViewModel: ServicesGoalList { }
