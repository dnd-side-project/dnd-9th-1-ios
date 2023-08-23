//
//  LoginViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/21.
//

import Foundation

import KakaoSDKUser
import RxSwift
import RxKakaoSDKUser

class OnboardingViewModel: BindableViewModel {
    
    var bag = DisposeBag()
    var apiSession: APIService = APISession()
    
    let idSubject = PublishSubject<String>()
    let tokenSubject = PublishSubject<Token>()
    var loginCoordinator: LoginFlow?
    
    let appleUserIdSubject = PublishSubject<String>()
    
    func kakaoLogin() {
        let fcmObservable = KeychainManager.shared.rx
            .retrieveItem(ofClass: .password, key: KeychainKeyList.fcmToken.rawValue)
            .compactMap { $0 as String }
        
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { [unowned self] in
                guard let id = $0.id else { return }
                self.idSubject.onNext("\(id)")
            })
            .disposed(by: bag)
        
        Observable.combineLatest(idSubject.asObservable(), fcmObservable) { [unowned self] userId, fcmToken in
            self.requestToken(provider: "kakao", userId: userId, fcmToken: fcmToken)
        }
        .flatMap { $0 }
        .subscribe(onNext: { [unowned self] result in
            switch result {
            case .success(let response):
                self.tokenSubject.onNext(response.data)
            case .failure(let error):
                print(error)
            }
        })
        .disposed(by: bag)
        
        let mergedObservable = Observable.of(
            tokenSubject
                .map {
                    KeychainManager.shared.rx
                        .saveItem($0.accessToken, itemClass: .password, key: KeychainKeyList.accessToken.rawValue)
                },
            tokenSubject
                .map {
                    KeychainManager.shared.rx
                        .saveItem($0.refreshToken, itemClass: .password, key: KeychainKeyList.refreshToken.rawValue)
                })
        
        Observable.merge(mergedObservable)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.loginCoordinator?.coordinateToOnboarding()
            })
            .disposed(by: bag)
    }
    
    func appleLogin() {
        let fcmObservable = KeychainManager.shared.rx
            .retrieveItem(ofClass: .password, key: KeychainKeyList.fcmToken.rawValue)
            .compactMap { $0 as String }
        
        Observable.combineLatest(fcmObservable, appleUserIdSubject.asObservable()) { [unowned self]  fcm, userId in
            self.requestToken(provider: "apple", userId: userId, fcmToken: fcm)
        }
        .flatMap { $0 }
        .subscribe(onNext: { [unowned self] result in
            switch result {
            case .success(let response):
                tokenSubject.onNext(response.data)
            case .failure(let error):
                print(error)
            }
        })
        .disposed(by: bag)
        
        let mergedObservable = Observable.of(
            tokenSubject
                .map {
                    KeychainManager.shared.rx
                        .saveItem($0.accessToken, itemClass: .password, key: KeychainKeyList.accessToken.rawValue)
                },
            tokenSubject
                .map {
                    KeychainManager.shared.rx
                        .saveItem($0.refreshToken, itemClass: .password, key: KeychainKeyList.refreshToken.rawValue)
                })
        
        Observable.merge(mergedObservable)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.loginCoordinator?.coordinateToOnboarding()
            })
            .disposed(by: bag)
    }
}

extension OnboardingViewModel: ServicesUser { }
