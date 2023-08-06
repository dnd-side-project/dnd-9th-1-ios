//
//  APIService.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Alamofire
import Foundation
import RxSwift

final class APIService: Requestable {
    func request<T: Decodable>(with request: URLRequest) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            let task = AF.request(request)
                .responseJSON { response in
                    
                    guard let statusCode = response.response?.statusCode else {
                        observer.onNext(.failure(.unknown))
                        return
                    }
                    
                    guard (200 ... 399).contains(statusCode) else {
                        observer.onNext(.failure(.http(status: statusCode)))
                        return
                    }
                    
                    guard let decoded = response.data?.decode(T.self) else {
                        observer.onNext(.failure(.decode))
                        return
                    }
                    
                    observer.onNext(.success(decoded))
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
