//
//  DetailParentViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/22.
//

import UIKit

import RxCocoa
import RxSwift

class DetailParentViewModel: BindableViewModel, ServicesGoalList, ServicesDetailGoal {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Properties
    
    var parentGoalId: Int = 0
    var detailGoalId: Int = 0
    var selectedParentGoal: ParentGoal?
    let stoneImageArray = [ImageLiteral.imgDetailStoneVer1, ImageLiteral.imgDetailStoneVer2, ImageLiteral.imgDetailStoneVer3,
                           ImageLiteral.imgDetailStoneVer4, ImageLiteral.imgDetailStoneVer5, ImageLiteral.imgDetailStoneVer6,
                           ImageLiteral.imgDetailStoneVer7, ImageLiteral.imgDetailStoneVer8, ImageLiteral.imgDetailStoneVer9]
    let completedImageArray = [ImageLiteral.imgCompletedStoneVer1, ImageLiteral.imgCompletedStoneVer2, ImageLiteral.imgCompletedStoneVer3,
                               ImageLiteral.imgCompletedStoneVer4, ImageLiteral.imgCompletedStoneVer5, ImageLiteral.imgCompletedStoneVer6,
                               ImageLiteral.imgCompletedStoneVer7, ImageLiteral.imgCompletedStoneVer8, ImageLiteral.imgCompletedStoneVer9]
    var isFull = false // 목표 9개가 꽉 찼는지
    
    // MARK: - Output
    
    var popDetailParentVC = BehaviorRelay(value: false)
    var detailGoalList = BehaviorRelay<[DetailGoal]>(value: [])
    var test = BehaviorRelay<[DetailGoal]>(value: [])
    // detailGoalList를 정렬한, 테이블뷰에 보여줄 데이터
    lazy var sortedGoalData = BehaviorRelay<[DetailGoal]>(value: sortGoalForCheckList())
    
    var detailGoalListResponse: Observable<Result<BaseModel<[DetailGoal]>, APIError>> {
        requestDetailGoalList(id: selectedParentGoal?.identity ?? 0)
    }
    var detailGoalCompleteResponse: Observable<Result<BaseModel<CompletedDetailGoal>, APIError>> {
        requestCompleteDetailGoal(id: detailGoalId)
    }
    var detailGoalIncompleteResponse: Observable<Result<EmptyDataModel, APIError>> {
        requestIncompleteDetailGoal(id: detailGoalId)
    }
    
    // 현재 상위 목표의 데이터
    var thisParentGoal: PublishRelay<ParentGoalInfo> = PublishRelay()
    // 현재 세부 목표의 데이터
    var thisDetailGoal: PublishRelay<DetailGoalInfo> = PublishRelay()
    
    deinit {
        bag = DisposeBag()
    }
    
    // MARK: - Functions
    
    /// 체크리스트(TableView)를 위해 detailGoalList를 정렬하는 함수
    /// 리스트는 id순(작성순)으로 정렬되어야 한다
    /// 또한 완료된 목표는 완료되지 않은 목표들보다 뒤에 위치해야 한다
    private func sortGoalForCheckList() -> [DetailGoal] {
        return detailGoalList.value.sorted {
            if $0.isCompleted == $1.isCompleted {
                return $0.detailGoalId < $1.detailGoalId
            } else {
                return !$0.isCompleted && $1.isCompleted
            }
        }
    }
}

extension DetailParentViewModel {
    func retrieveDetailGoalList() {
        detailGoalListResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    isFull = response.data.count > 9
                    detailGoalList.accept(response.data)
                    sortedGoalData.accept(sortGoalForCheckList()) // 정렬
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
    
    func completeDetailGoal() {
        detailGoalCompleteResponse
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    retrieveDetailGoalList()
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            }
            .disposed(by: bag)
    }
    
    func incompleteDetailGoal() {
        detailGoalIncompleteResponse
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    retrieveDetailGoalList()
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            }
            .disposed(by: bag)
    }
    
    /// 상위 목표 생성
    func createParentGoal(reqBody: CreateParentGoal) {
        var createParentGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestPostParentGoal(reqBody: reqBody)
        }
        
        createParentGoalResponse
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 상위 목표 수정
    func modifyParentGoal(reqBody: Goal) {
        var modifyParentGoalResponse: Observable<Result<BaseModel<ParentGoalInfo>, APIError>> {
            requestModifyParentGoal(id: parentGoalId, reqBody: reqBody)
        }
        
        modifyParentGoalResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    thisParentGoal.accept(response.data)
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 상위 목표 삭제
    func deleteParentGoal() {
        var deleteParentGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestDeleteParentGoal(id: selectedParentGoal?.identity ?? 0)
        }
        
        deleteParentGoalResponse
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 세부 목표 생성
    func createDetailGoal(reqBody: NewDetailGoal) {
        var createDetailGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestPostDetailGoal(id: selectedParentGoal?.identity ?? 0, reqBody: reqBody)
        }
        
        createDetailGoalResponse
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 세부 목표 상세 정보 조회
    func retrieveDetailGoalInfo() {
        var retrieveDetailGoalInfoResponse: Observable<Result<BaseModel<DetailGoalInfo>, APIError>> {
            requestDetailGoalInfo(id: detailGoalId)
        }
        
        retrieveDetailGoalInfoResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    thisDetailGoal.accept(response.data)
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
}
