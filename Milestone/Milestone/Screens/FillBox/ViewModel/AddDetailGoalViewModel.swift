//
//  AddDetailGoalViewModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/24.
//

import UIKit

import RxCocoa
import RxSwift

// MARK: - 세부 목표 추가 화면 VM

class AddDetailGoalViewModel: BindableViewModel, ServicesDetailGoal {
    
    // MARK: - BindableViewModel Properties
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
        
    // MARK: - Properties
    
    deinit {
        bag = DisposeBag()
    }
}

extension AddDetailGoalViewModel {
    func createDetailGoal(id: Int, reqBody: DetailGoalInfo) {
        var createDetailGoalResponse: Observable<Result<EmptyDataModel, APIError>> {
            requestPostDetailGoal(id: id, reqBody: reqBody)
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
}
