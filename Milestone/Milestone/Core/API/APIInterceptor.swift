//
//  APIInterceptor.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/22.
//

import Foundation

import Alamofire
import RxSwift

class APIInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        if checkIsRegisterAPI(urlRequest: urlRequest) {
            completion(.success(urlRequest))
            return
        }
        
        guard let accessToken: String = try? KeychainManager.shared.retrieveItem(ofClass: .password, key: KeychainKeyList.accessToken.rawValue) else {
            print("NIL")
            return
        }
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        
        completion(.success(urlRequest))
    }

//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        <#code#>
//    }
    
    func checkIsRegisterAPI(urlRequest: URLRequest) -> Bool {
        if urlRequest.url!.relativePath == "/auth/kakao" || urlRequest.url!.relativePath == "/auth/apple" {
            return true
        } else {
            return false
        }
    }
}
