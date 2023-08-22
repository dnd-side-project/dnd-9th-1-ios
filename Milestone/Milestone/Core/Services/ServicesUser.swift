//
//  ServicesUser.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation
import RxSwift

protocol ServicesUser: Service {
//    Observable<Result<BaseModel<[Goal]>, APIError>>
    func requestToken(provider: String, userId: String, fcmToken: String) -> Observable<Result<BaseModel<Token>, APIError>>
}

extension ServicesUser {
    func requestToken(provider: String, userId: String, fcmToken: String) -> Observable<Result<BaseModel<Token>, APIError>> {
        return apiSession.request(.login(provider: provider, userId: userId, fcmToken: fcmToken))
    }
}
