//
//  APISession.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import Alamofire
import RxSwift

class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}

struct APISession: APIService {
    
    /// 네트워크 요청 함수 - 제네릭 옵저버블을 리턴
    func request<T: Codable> (_ request: APIRouter) -> Observable<Result<T, APIError>> {
        return Observable<Result<T, APIError>>.create { observer in
            
            /// Alamofire 네트워크 요청함수 호출
            let request = API.session.request(request, interceptor: APIInterceptor()).responseDecodable { (response: DataResponse<T, AFError>) in
                
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
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
