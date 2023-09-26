//
//  LoginViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/21.
//

import Foundation

import KakaoSDKUser
import RxCocoa
import RxSwift
import RxKakaoSDKUser

class OnboardingViewModel: BindableViewModel {
    
    var bag = DisposeBag()
    var apiSession: APIService = APISession()
    var loginCoordinator: LoginFlow?
    
    /// FCM 토큰 옵저버블
    let fcmObservable = KeychainManager.shared.rx
        .retrieveItem(ofClass: .password, key: KeychainKeyList.fcmToken.rawValue)
    
    /// 소셜로그인 id값 프로퍼티
    let kakaoUserId = UserApi.shared.rx.me()
        .asObservable()
        .compactMap { $0.id }
        .map { String($0) }
    var appleUserId: String!
    var isFirstLogin = false
    
    /// 로그인 진행
    /// 1. 프로바이더에 따라 로그인 함수 호출
    /// 2. 로그인 함수 내에서 토큰 저장함수 재호출
    func loginWith(provider: LoginType) {
        switch provider {
        case .apple:
            fcmObservable
                .flatMapLatest { [unowned self] in self.requestToken(provider: "apple", userId: appleUserId, fcmToken: $0)}
                .flatMapLatest { [unowned self] in
                    self.saveToken(result: $0)
                }
                .subscribe(onError: {
                    print("ERR: ",$0)
                }, onCompleted: { [unowned self] in
                    if self.isFirstLogin {
                        self.loginCoordinator?.coordinateToOnboarding()
                    } else {
                        self.loginCoordinator?.coordinateToMain()
                    }
                })
                .disposed(by: bag)
        case .kakao:
            fcmObservable
                .flatMapLatest { [unowned self] in self.kakaoLogin(fcmToken: $0) }
                .flatMapLatest { [unowned self] in self.saveToken(result: $0) }
                .subscribe(onError: {
                    // MARK: 에러처리 필요
                    print($0)
                }, onCompleted: { [unowned self] in
                    if self.isFirstLogin {
                        self.loginCoordinator?.coordinateToOnboarding()
                    } else {
                        self.loginCoordinator?.coordinateToMain()
                    }
                })
                .disposed(by: bag)
        }
    }
    
    func kakaoLogin(fcmToken: String) -> Observable<Result<BaseModel<Token>, APIError>> {
        kakaoUserId
            .flatMap { [unowned self] in
                self.requestToken(provider: "kakao", userId: $0, fcmToken: fcmToken)
            }
    }
    
    func appleLogin(fcmToken: String) -> Observable<Result<BaseModel<Token>, APIError>> {
        self.requestToken(provider: "apple", userId: appleUserId, fcmToken: fcmToken)
    }
    
    func saveToken(result: Result<BaseModel<Token>, APIError>) -> Observable<Bool> {
        switch result {
        case .success(let response):
            let accessTokenObservable = KeychainManager.shared.rx
                .saveItem(response.data.accessToken, itemClass: .password, key: KeychainKeyList.accessToken.rawValue)
            let refreshTokenObservable = KeychainManager.shared.rx
                .saveItem(response.data.refreshToken, itemClass: .password, key: KeychainKeyList.refreshToken.rawValue)
            
            self.isFirstLogin = response.data.isFirstLogin
            
            return accessTokenObservable.concat(refreshTokenObservable)
                .map { true }
        case .failure(let error):
            return Observable.error(error)
        }
    }
    
    func addUpperGoal(goal: CreateUpperGoal) -> Observable<Result<EmptyDataModel, APIError>> {
        return requestPostUpperGoal(reqBody: goal)
    }
}

extension OnboardingViewModel: ServicesUser, ServicesGoalList { }
