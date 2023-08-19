//
//  ServicesPost.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation
import RxSwift

protocol ServicesPost: Service {
    func createPost() -> Observable<Result<Post, APIError>>
    func getPost() -> Observable<Result<[Post], APIError>>
}

extension ServicesPost {
    func createPost() -> Observable<Result<Post, APIError>> {
        return apiSession.request(.createPost(post: Post(id: 1, title: "타이틀", body: "바디", userId: 1)))
    }
    
    func getPost() -> Observable<Result<[Post], APIError>> {
        return apiSession.request(.getPosts(id: 1))
    }
}
