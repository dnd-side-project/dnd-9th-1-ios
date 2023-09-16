//
//  Requestable.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation
import RxSwift

protocol Requestable {
    func request<T: Decodable>(with request: URLRequest) -> Observable<Result<T, APIError>>
}
