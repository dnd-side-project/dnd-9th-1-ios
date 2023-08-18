//
//  ServicesUser.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation
import RxSwift

protocol ServicesUser: Service {
    func getPost() -> Observable<Result<Post, APIError>>
}

extension ServicesUser {
    func getPost() -> Observable<Result<Post, APIError>> {
        return apiSession.request(.getPosts(id: 0))
    }
}
