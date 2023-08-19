//
//  APIRouter.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    /// 엔드포인트 리스트
    case getPosts(id: Int)
    case createPost(post: Post)
    
    // MARK: - HttpMethod
    /// switch - self 구문으로 각 엔드포인트별 메서드 지정
    private var method: HTTPMethod {
        switch self {
        case .getPosts:
            return .get
        case .createPost:
            return .post
        }
    }
    
    //MARK: - Path
    /// switch - self 구문으로 각 엔드포인트별 URL Path 지정
    private var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        case .createPost:
            return "/posts"
        }
    }
    
    //MARK: - Parameters
    /// request body 정의
    /// 빈 body를 보낼때는 nil값 전달
    private var parameters: Parameters? {
        switch self {
        case .getPosts:
            return nil
        case .createPost(let post):
            return [
                K.Parameters.id: post.id,
                K.Parameters.title: post.title,
                K.Parameters.body: post.body,
                K.Parameters.userId: post.userId
            ]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        /// self의 method 속성을 참조
        urlRequest.httpMethod = method.rawValue
        
        /// 네트워크 통신 일반에 사용되는 헤더 기본추가
        urlRequest.setValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HttpHeaderField.contentType.rawValue)
        
        /// 요청 바디 인코딩
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
