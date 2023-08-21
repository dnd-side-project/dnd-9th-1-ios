//
//  APIError.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

/// API 에러 리스트
/// 1. decode - JSON 디코딩 에러
/// 2. unknown - 언노운 에러
/// 3. forbidden - Forbidden 에러
/// 4. notFound - URL이 존재하지 않아 발생한 not found 에러
/// 5. unauthorized - 토큰만료 등으로 인한 권한에러
/// 6. internalServerError - 500 서버에러
enum APIError: Error {
    case decode
    case http(status: Int)
    case unknown
}

/// API 에러 스트링으로 변환
extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .decode:
            return "Decode Error"
        case let .http(status):
            return "HTTP Error: \(status)"
        case .unknown:
            return "Unknown Error"
        }
    }
}
