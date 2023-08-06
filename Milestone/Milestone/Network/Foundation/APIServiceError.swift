//
//  APIServiceError.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

enum APIServiceError: Error {
    case urlEncodingError
    case clientError(message: String?)
    case serverError
}
