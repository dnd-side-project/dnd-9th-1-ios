//
//  SceneCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/11.
//

import UIKit
import RxCocoa
import RxSwift

class SceneCoordinator: SceneCoordinatorType{
    
    private let bag = DisposeBag()
    
    private var window: UIWindow
    private var currentVC: UIViewController!
    
    required init(window: UIWindow){
        self.window = window
        self.currentVC = window.rootViewController
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        // Next이벤트를 방출하지 않고, onCompleted와 onError만 방출하기 때문에 타입 지정은 하지 않음
        let subject = PublishSubject<Never>()
        
        let target = scene.instantiate()
        
        switch style {
        case .root:
            currentVC = target
            window.rootViewController = currentVC
            
            subject.onCompleted()
        case .push:
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.pushViewController(target, animated: animated)
            currentVC = target
            
            subject.onCompleted()
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentVC = target
        }
        
        return subject.asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> RxSwift.Completable {
        let subject = PublishSubject<Never>()
        
        /// 현재 Scene이 모달 형태로 띄워져 있을때
        if let presentingVC = self.currentVC.presentingViewController{
            currentVC.dismiss(animated: animated) { [unowned self] in
                self.currentVC = presentingVC
                subject.onCompleted()
            }
        /// 현재 Scene이 네비게이션 내에 푸시되어 있을때
        } else if let nav = self.currentVC.navigationController {
            guard nav.popViewController(animated: animated) != nil else {
                subject.onError(TransitionError.cannotPop)
                return subject.asCompletable()
            }
            
            self.currentVC = nav.viewControllers.last!
            subject.onCompleted()
        }else{
            subject.onError(TransitionError.unknown )
        }
        
        
        
        return subject.asCompletable()
    }
}
