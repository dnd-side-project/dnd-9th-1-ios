//
//  ServicesUser.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation
import RxSwift

protocol ServicesUser: Service {
    func requestToken(provider: String, userId: String, fcmToken: String) -> Observable<Result<BaseModel<Token>, APIError>>
    func requestRefreshToken() -> Observable<Result<BaseModel<Token>, APIError>>
    func authTest() -> Observable<Result<String, APIError>>
    func logout() -> Observable<Result<BaseModel<EmptyDataModel>, APIError>>
    func withdraw() -> Observable<Result<BaseModel<EmptyDataModel>, APIError>>
}

extension ServicesUser {
    func requestToken(provider: String, userId: String, fcmToken: String) -> Observable<Result<BaseModel<Token>, APIError>> {
        return apiSession.request(.login(provider: provider, userId: userId, fcmToken: fcmToken))
    }
    
    func requestRefreshToken() -> Observable<Result<BaseModel<Token>, APIError>> {
        return apiSession.request(.reissue)
    }
    
    func authTest() -> Observable<Result<String, APIError>> {
        return apiSession.request(.authTest)
    }
    
    func logout() -> Observable<Result<BaseModel<EmptyDataModel>, APIError>> {
        return apiSession.request(.logout)
    }
    
    func withdraw() -> Observable<Result<BaseModel<EmptyDataModel>, APIError>> {
        return apiSession.request(.withdraw)
    }
}
