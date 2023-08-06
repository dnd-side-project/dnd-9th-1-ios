//
//  NetworkRequest.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

struct NetworkRequest {
    let url: String
    let headers: [String: String]?
    let body: Data?
    let requestTimeOut: Float?
    let httpMethod: HttpMethod
    
    init(url: String,
         headers: [String: String]? = nil,
         reqBody: Data? = nil,
         reqTimeout: Float? = nil,
         httpMethod: HttpMethod
    ) {
        self.url = url
        self.headers = headers
        self.body = reqBody
        self.requestTimeOut = reqTimeout
        self.httpMethod = httpMethod
    }
    
    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        urlRequest.httpBody = body
        return urlRequest
    }
}
