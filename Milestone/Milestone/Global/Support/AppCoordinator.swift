//
//  AppCoordinator.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/12.
//

import UIKit

import KakaoSDKAuth
import RxKakaoSDKAuth
import RxSwift

class AppCoordinator: Coordinator {
    private let window: UIWindow
    var disposeBag = DisposeBag()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    /// 카카오 로그인 여부 & 애플 로그인 여부 체크 후 메인화면으로 이동
    /// 로그아웃 이후에는 각각 revoke시킨 뒤 로그인으로 이동시키도록 분기처리 필요
    func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        KeychainManager.shared.rx.retrieveItem(ofClass: .password, key: KeychainKeyList.refreshToken.rawValue)
            .subscribe(onNext: {
                if !$0.isEmpty {
                    navigationController.pushViewController(MainViewController(), animated: false)
                }
            }, onError: { [weak self] error in
                guard let error = error as? KeychainError else {
                    return
                }
                if error.localizedDescription == "Item not found" {
                    self?.coordinate(to: LoginCoordinator(navigationController: navigationController))
                }
            })
            .disposed(by: disposeBag)
    }
}
