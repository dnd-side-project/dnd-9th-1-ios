//
//  APIInterceptor.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/22.
//

import UIKit

import Alamofire
import RxSwift

class APIInterceptor: RequestInterceptor {
    let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        if checkIsRegisterAPI(urlRequest: urlRequest) {
            completion(.success(urlRequest))
            return
        }
        
        if checkIsReissueAPI(urlRequest: urlRequest) {
            guard let refreshToken: String = try? KeychainManager.shared.retrieveItem(ofClass: .password, key: KeychainKeyList.refreshToken.rawValue) else {
                return
            }
            var urlRequest = urlRequest
            urlRequest.headers.add(.authorization(bearerToken: refreshToken))
            completion(.success(urlRequest))
            return
        } else {
            guard let accessToken: String = try? KeychainManager.shared.retrieveItem(ofClass: .password, key: KeychainKeyList.accessToken.rawValue) else {
                print("NIL")
                return
            }
            var urlRequest = urlRequest
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
            
            completion(.success(urlRequest))
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        if let url = request.response?.url {
            if url.relativePath == "/auth/reissue" {
                completion(.doNotRetryWithError(APIError.http(status: 401)))
            } else {
                APIRefreshTask().requestRefreshToken()
                    .subscribe(onNext: {[unowned self] result in
                        switch result {
                        case .success(let response):
                            KeychainManager.shared.rx.saveItem(response.data.accessToken, itemClass: .password, key: KeychainKeyList.accessToken.rawValue)
                                .subscribe(onNext: {
                                    print("accessToken save completed!")
                                })
                                .disposed(by: self.disposeBag)
                            KeychainManager.shared.rx.saveItem(response.data.refreshToken, itemClass: .password, key: KeychainKeyList.refreshToken.rawValue)
                                .subscribe(onNext: {
                                    print("refreshToken save completed!")
                                })
                                .disposed(by: self.disposeBag)
                            print("SAVE COMPLETED!")
                            completion(.retry)
                        case .failure:
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                                guard let self = self else { return }
                                let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
                                let root = window?.rootViewController
                                
                                let accessTokenObservable = KeychainManager.shared.rx
                                    .deleteItem(ofClass: .password, key: KeychainKeyList.accessToken.rawValue)
                                let refreshTokenObservable = KeychainManager.shared.rx
                                    .deleteItem(ofClass: .password, key: KeychainKeyList.refreshToken.rawValue)
                                
                                Observable.combineLatest(accessTokenObservable, refreshTokenObservable)
                                    .subscribe(onCompleted: {
                                        AppCoordinator(window: window!).start()
                                    })
                                    .disposed(by: self.disposeBag)                            }
                            completion(.doNotRetry)
                        }
                    })
                    .disposed(by: disposeBag)
            }
        }
       
    }
    
    func checkIsRegisterAPI(urlRequest: URLRequest) -> Bool {
        if urlRequest.url!.relativePath == "/auth/kakao" || urlRequest.url!.relativePath == "/auth/apple" {
            return true
        } else {
            return false
        }
    }
    
    func checkIsReissueAPI(urlRequest: URLRequest) -> Bool {
        if urlRequest.url!.relativePath == "/auth/reissue" {
            return true
        } else {
            return false
        }
    }
}

class APIRefreshTask: ServicesUser {
    var apiSession: APIService = APISession()
}
