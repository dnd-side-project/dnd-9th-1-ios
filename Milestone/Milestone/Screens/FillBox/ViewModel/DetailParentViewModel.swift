//
//  DetailParentViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/22.
//

import UIKit

import RxCocoa
import RxSwift

class DetailParentViewModel: BindableViewModel {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Properties
    
    let stoneImageArray = [ImageLiteral.imgDetailStoneVer1, ImageLiteral.imgDetailStoneVer2, ImageLiteral.imgDetailStoneVer3,
                           ImageLiteral.imgDetailStoneVer4, ImageLiteral.imgDetailStoneVer5, ImageLiteral.imgDetailStoneVer6,
                           ImageLiteral.imgDetailStoneVer7, ImageLiteral.imgDetailStoneVer8, ImageLiteral.imgDetailStoneVer9]
    let completedImageArray = [ImageLiteral.imgCompletedStoneVer1, ImageLiteral.imgCompletedStoneVer2, ImageLiteral.imgCompletedStoneVer3,
                               ImageLiteral.imgCompletedStoneVer4, ImageLiteral.imgCompletedStoneVer5, ImageLiteral.imgCompletedStoneVer6,
                               ImageLiteral.imgCompletedStoneVer7, ImageLiteral.imgCompletedStoneVer8, ImageLiteral.imgCompletedStoneVer9]
    
    private var detailGoalList = [
        DetailGoal(detailGoalId: 0, title: "세부1", isCompleted: true),
        DetailGoal(detailGoalId: 0, title: "세부2", isCompleted: true),
        DetailGoal(detailGoalId: 0, title: "세부3", isCompleted: false),
        DetailGoal(detailGoalId: 0, title: "세부4", isCompleted: true),
        DetailGoal(detailGoalId: 0, title: "세부5", isCompleted: false),
        DetailGoal(detailGoalId: 0, title: "세부6", isCompleted: true),
        DetailGoal(detailGoalId: 0, title: "세부7", isCompleted: true),
        DetailGoal(detailGoalId: 0, title: "세부8", isCompleted: false),
        DetailGoal(detailGoalId: 0, title: "세부9", isCompleted: true)
    ]
    // detailGoalList를 정렬한, 테이블뷰에 보여줄 데이터
    lazy var sortedGoalData: [DetailGoal] = {
        return sortGoalForCheckList()
    }()
    private lazy var storeForCollectionView = BehaviorSubject<[DetailGoal]>(value: detailGoalList)
    private lazy var storeForTableView = BehaviorSubject<[DetailGoal]>(value: sortedGoalData)
    
    var detailGoalObservableForCollectionView: Observable<[DetailGoal]> {
        return storeForCollectionView
    }
    var detailGoalObservableForTableView: Observable<[DetailGoal]> {
        return storeForTableView
    }
    
    deinit {
        bag = DisposeBag()
    }
    
    // MARK: - Functions
    
    /// 체크리스트(TableView)를 위해 detailGoalList를 정렬하는 함수
    /// 리스트는 id순(작성순)으로 정렬되어야 한다
    /// 또한 완료된 목표는 완료되지 않은 목표들보다 뒤에 위치해야 한다
    private func sortGoalForCheckList() -> [DetailGoal] {
        return detailGoalList.sorted {
            if $0.isCompleted == $1.isCompleted {
                return $0.detailGoalId < $1.detailGoalId
            } else {
                return !$0.isCompleted && $1.isCompleted
            }
        }
    }
}
