//
//  DetailUpperViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/22.
//

import UIKit

import RxCocoa
import RxSwift

class DetailUpperViewModel: BindableViewModel, ServicesGoalList, ServicesLowerGoal {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Properties
    
    var upperGoalId: Int = 0
    var lowerGoalId: Int = 0
    var selectedUpperGoal: UpperGoal?
    let stoneImageArray = [ImageLiteral.imgDetailStoneVer1, ImageLiteral.imgDetailStoneVer2, ImageLiteral.imgDetailStoneVer3,
                           ImageLiteral.imgDetailStoneVer4, ImageLiteral.imgDetailStoneVer5, ImageLiteral.imgDetailStoneVer6,
                           ImageLiteral.imgDetailStoneVer7, ImageLiteral.imgDetailStoneVer8, ImageLiteral.imgDetailStoneVer9]
    let completedImageArray = [ImageLiteral.imgCompletedStoneVer1, ImageLiteral.imgCompletedStoneVer2, ImageLiteral.imgCompletedStoneVer3,
                               ImageLiteral.imgCompletedStoneVer4, ImageLiteral.imgCompletedStoneVer5, ImageLiteral.imgCompletedStoneVer6,
                               ImageLiteral.imgCompletedStoneVer7, ImageLiteral.imgCompletedStoneVer8, ImageLiteral.imgCompletedStoneVer9]
    var isFull = false // 목표 9개가 꽉 찼는지
    
    // MARK: - Output
    
    var popDetailUpperVC = BehaviorRelay(value: false)
    var lowerGoalList = BehaviorRelay<[LowerGoal]>(value: [])
    var test = BehaviorRelay<[LowerGoal]>(value: [])
    var completedGoalResult = BehaviorRelay<StateUpdatedUpperGoal>(value: StateUpdatedUpperGoal(isGoalCompleted: false, completedGoalCount: 0))
    // lowerGoalList를 정렬한, 테이블뷰에 보여줄 데이터
    lazy var sortedGoalData = BehaviorRelay<[LowerGoal]>(value: sortGoalForCheckList())
    
    var lowerGoalListResponse: Observable<Result<BaseModel<[LowerGoal]>, APIError>> {
        requestLowerGoalList(id: selectedUpperGoal?.goalId ?? 0)
    }
    var lowerGoalCompleteResponse: Observable<Result<BaseModel<StateUpdatedUpperGoal>, APIError>> {
        requestCompleteLowerGoal(id: lowerGoalId)
    }
    var lowerGoalIncompleteResponse: Observable<Result<EmptyDataModel, APIError>> {
        requestIncompleteLowerGoal(id: lowerGoalId)
    }
    
    // 현재 상위 목표의 데이터
    var thisUpperGoal: PublishRelay<UpperGoalInfo> = PublishRelay()
    // 현재 하위 목표의 데이터
    var thisLowerGoal = BehaviorRelay<LowerGoalInfo>(value: LowerGoalInfo(detailGoalId: 0, title: "", alarmTime: "", alarmDays: [], alarmEnabled: true))
    
    deinit {
        bag = DisposeBag()
    }
    
    // MARK: - Functions
    
    /// 체크리스트(TableView)를 위해 lowerGoalList를 정렬하는 함수
    /// 리스트는 id순(작성순)으로 정렬되어야 한다
    /// 또한 완료된 목표는 완료되지 않은 목표들보다 뒤에 위치해야 한다
    private func sortGoalForCheckList() -> [LowerGoal] {
        return lowerGoalList.value.sorted {
            if $0.isCompleted == $1.isCompleted {
                return $0.detailGoalId < $1.detailGoalId
            } else {
                return !$0.isCompleted && $1.isCompleted
            }
        }
    }
}

extension DetailUpperViewModel {
    func retrieveLowerGoalList() {
        lowerGoalListResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    isFull = response.data.count > 9
                    lowerGoalList.accept(response.data)
                    sortedGoalData.accept(sortGoalForCheckList()) // 정렬
                    if !isFull {
                        // 9개가 다 차지 않았다면 하위 목표 생성 셀 추가
                        var arr = response.data
                        arr.append(LowerGoal(detailGoalId: -1, title: "하위 목표를 추가해주세요!", isCompleted: false))
                        test.accept(arr)
                    }
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 하위 목표 완료
    func completeLowerGoal() {
        lowerGoalCompleteResponse
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    retrieveLowerGoalList()
                    completedGoalResult.accept(response.data)
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            }
            .disposed(by: bag)
    }
    
    func incompleteLowerGoal() {
        lowerGoalIncompleteResponse
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    retrieveLowerGoalList()
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            }
            .disposed(by: bag)
    }
    
    /// 상위 목표 생성
    func createUpperGoal(reqBody: CreateUpperGoal) {
        var createUpperGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestPostUpperGoal(reqBody: reqBody)
        }
        
        createUpperGoalResponse
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
    func modifyUpperGoal(reqBody: Goal) {
        var modifyUpperGoalResponse: Observable<Result<BaseModel<UpperGoalInfo>, APIError>> {
            requestModifyUpperGoal(id: upperGoalId, reqBody: reqBody)
        }
        
        modifyUpperGoalResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    thisUpperGoal.accept(response.data)
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 상위 목표 삭제
    func deleteUpperGoal() {
        var deleteUpperGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestDeleteUpperGoal(id: selectedUpperGoal?.goalId ?? 0)
        }
        
        deleteUpperGoalResponse
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
    
    /// 상위 목표 복구 API
    func restoreUpperGoal(reqBody: Goal) {
        var restoreUpperGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestRestoreUpperGoal(id: selectedUpperGoal?.goalId ?? 0, reqBody: reqBody)
        }
        
        restoreUpperGoalResponse
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
    
    /// 하위 목표 생성
    func createLowerGoal(reqBody: NewLowerGoal) {
        var createLowerGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestPostLowerGoal(id: selectedUpperGoal?.goalId ?? 0, reqBody: reqBody)
        }
        
        createLowerGoalResponse
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
    
    /// 하위 목표 상세 정보 조회
    func retrieveLowerGoalInfo() {
        var retrieveLowerGoalInfoResponse: Observable<Result<BaseModel<LowerGoalInfo>, APIError>> {
            requestLowerGoalInfo(id: lowerGoalId)
        }
        
        retrieveLowerGoalInfoResponse
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let response):
                    thisLowerGoal.accept(response.data) // thisLowerGoal 값 설정
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 하위 목표 수정 API
    func modifyLowerGoal(reqBody: NewLowerGoal) {
        var modifyLowerGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestEditLowerGoal(id: lowerGoalId, reqBody: reqBody)
        }
        
        modifyLowerGoalResponse
            .subscribe { result in
                switch result {
                case .success(let response):
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            }
            .disposed(by: bag)
    }
    /// 하위 목표 삭제 API
    func deleteLowerGoal() {
        var modifyLowerGoalResponse: Observable<Result<BaseModel<StateUpdatedUpperGoal>, APIError>> {
            requestDeleteLowerGoal(id: lowerGoalId)
        }
        
        modifyLowerGoalResponse
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    retrieveLowerGoalList()
                    completedGoalResult.accept(response.data) // 삭제하고 받은 응답값 방출
                    Logger.debugDescription(response)
                case .failure(let error):
                    Logger.debugDescription(error)
                }
            }
            .disposed(by: bag)
    }
}
