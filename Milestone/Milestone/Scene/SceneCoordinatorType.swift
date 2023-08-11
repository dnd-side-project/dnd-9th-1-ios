//
//  SceneCoordinatorType.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/11.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType{
    /// 대상 Scene을 표시하는 함수
    /// Completable은 Observable<Void>과 동일
    /// dismiss의 completion 클로저와 동일한 역할을 함. 구독하여 화면 전환 이후의 동작을 구독자에게 전달하고 싶으면 사용
    /// 굳이 구현하고 싶지 않으면 구현하지 않아도 되기 때문에 discardableResult 키워드 차용
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    /// 현재 Scene을 닫고 이전 Scene으로 이동
    @discardableResult
    func close(animated: Bool) -> Completable
}
