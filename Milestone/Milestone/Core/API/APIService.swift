//
//  APIService.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import Alamofire
import RxSwift

protocol APIService {
    func request<T: Codable> (_ request: APIRouter) -> Observable<Result<T, APIError>>
}
