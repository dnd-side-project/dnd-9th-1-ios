//
//  APIEnvironment.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

enum APIEnvironment: String, CaseIterable {
    case dev
    case prod
}

extension APIEnvironment {
    var baseUrl: String {
        switch self {
        case .dev:
            return "개발서버url"
        case .prod:
            return "배포서버url"
        }
    }
    
    var token: String {
        return "토큰더미데이터"
    }
}
