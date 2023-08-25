//
//  DetailParentViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/22.
//

import UIKit

import RxCocoa
import RxSwift

class DetailParentViewModel: BindableViewModel, ServicesDetailGoal {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Properties
    
    var parentGoalId: Int = 0
    let stoneImageArray = [ImageLiteral.imgDetailStoneVer1, ImageLiteral.imgDetailStoneVer2, ImageLiteral.imgDetailStoneVer3,
                           ImageLiteral.imgDetailStoneVer4, ImageLiteral.imgDetailStoneVer5, ImageLiteral.imgDetailStoneVer6,
                           ImageLiteral.imgDetailStoneVer7, ImageLiteral.imgDetailStoneVer8, ImageLiteral.imgDetailStoneVer9]
    let completedImageArray = [ImageLiteral.imgCompletedStoneVer1, ImageLiteral.imgCompletedStoneVer2, ImageLiteral.imgCompletedStoneVer3,
                               ImageLiteral.imgCompletedStoneVer4, ImageLiteral.imgCompletedStoneVer5, ImageLiteral.imgCompletedStoneVer6,
                               ImageLiteral.imgCompletedStoneVer7, ImageLiteral.imgCompletedStoneVer8, ImageLiteral.imgCompletedStoneVer9]
    var isFull = false // 목표 9개가 꽉 찼는지
    
    // MARK: - Output
    
    var isTest = BehaviorRelay(value: false)
    var detailGoalList = BehaviorRelay<[DetailGoal]>(value: [])
    var test = BehaviorRelay<[DetailGoal]>(value: [])
    // detailGoalList를 정렬한, 테이블뷰에 보여줄 데이터
//    lazy var sortedGoalData: [DetailGoal] = {
//        return sortGoalForCheckList()
//    }()
    
    var detailGoalListResponse: Observable<Result<BaseModel<[DetailGoal]>, APIError>> {
        requestDetailGoalList(id: parentGoalId)
    }
    
    deinit {
        bag = DisposeBag()
    }
    
    // MARK: - Functions
    
    /// 체크리스트(TableView)를 위해 detailGoalList를 정렬하는 함수
    /// 리스트는 id순(작성순)으로 정렬되어야 한다
    /// 또한 완료된 목표는 완료되지 않은 목표들보다 뒤에 위치해야 한다
//    private func sortGoalForCheckList() -> [DetailGoal] {
//        return detailGoalList.sorted {
//            if $0.isCompleted == $1.isCompleted {
//                return $0.detailGoalId < $1.detailGoalId
//            } else {
//                return !$0.isCompleted && $1.isCompleted
//            }
//        }
//    }
}

extension DetailParentViewModel {
    func retrieveDetailGoalList() {
        detailGoalListResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    isFull = response.data.count > 9
                    detailGoalList.accept(response.data)
                    if !isFull {
                        // 9개가 다 차지 않았다면 세부 목표 생성 셀 추가
                        var arr = response.data
                        arr.append(DetailGoal(detailGoalId: -1, title: "세부 목표를 추가해주세요!", isCompleted: false))
                        test.accept(arr)
                    }
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
}
