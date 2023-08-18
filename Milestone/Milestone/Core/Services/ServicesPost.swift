//
//  ServicesPost.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation
import RxSwift

protocol ServicesPost: Service {
    func getPost() -> Observable<Result<PostResponse, APIError>>
}

extension ServicesPost {
    func getPost() -> Observable<Result<PostResponse, APIError>> {
        return apiSession.request(.getPosts(id: 0))
    }
}
