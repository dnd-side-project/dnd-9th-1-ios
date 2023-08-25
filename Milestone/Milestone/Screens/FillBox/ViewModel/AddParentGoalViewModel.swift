//
//  AddParentGoalViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import UIKit

import RxCocoa
import RxSwift

class AddParentGoalViewModel: BindableViewModel, ServicesGoalList {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    
    // MARK: - Properties
    
    var parentGoalId: Int = 0
    
    deinit {
        bag = DisposeBag()
    }
}

extension AddParentGoalViewModel {
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
        var modifyParentGoalResponse: Observable<Result<Goal, APIError>> {
            requestModifyParentGoal(id: parentGoalId, reqBody: reqBody)
        }
        
        modifyParentGoalResponse
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
}
