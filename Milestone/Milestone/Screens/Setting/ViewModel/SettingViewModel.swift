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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self = self else { return }
                    self.removeTokens()
                    
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self = self else { return }
                    self.removeTokens()
                    
                    let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
                    let root = window?.rootViewController
                    AppCoordinator(window: window!).start()
                }
            })
            .disposed(by: bag)
    }
    
    func removeTokens() {
        KeychainManager.shared.rx.deleteItem(ofClass: .password, key: KeychainKeyList.refreshToken.rawValue)
            .debug()
            .subscribe(onNext: {
                print("refresh removed")
            })
            .disposed(by: bag)
        
        KeychainManager.shared.rx.deleteItem(ofClass: .password, key: KeychainKeyList.accessToken.rawValue)
            .debug()
            .subscribe(onNext: {
                print("access removed")
            })
            .disposed(by: bag)
    }
}

extension SettingViewModel: ServicesUser { }
