//
//  SettingViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/09/05.
//

import UIKit

import RxSwift

class SettingViewModel: BindableViewModel {
    var apiSession: APIService = APISession()
    
    var bag = DisposeBag()
    
    func handleLogout() {
        logout()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
                    let root = window?.rootViewController
                    AppCoordinator(window: window!).start()
                }
            })
            .disposed(by: bag)
    }
    
    func handleWithdraw() {
        withdraw()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
                    let root = window?.rootViewController
                    AppCoordinator(window: window!).start()
                }
            })
            .disposed(by: bag)
    }
}

extension SettingViewModel: ServicesUser { }
