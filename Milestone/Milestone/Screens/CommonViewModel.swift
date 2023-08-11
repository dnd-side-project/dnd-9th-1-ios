//
//  CommonViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/11.
//

import Foundation
import RxCocoa
import RxSwift

/// 공통 뷰모델 정의
class CommonViewModel: NSObject{
    let title: Driver<String> // 모든 Scene은 네비게이션 컨트롤러에 임베딩되므로 타이틀속성 부여
    
    let sceneCoordinator: SceneCoordinatorType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
    }
}
