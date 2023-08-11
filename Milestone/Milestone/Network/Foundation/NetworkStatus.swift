//
//  NetworkStatus.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

enum NetworkStatus: Int {
    case okay = 200
    case badRequest = 400
    case unAuthorized = 401
    case notFound = 404
    case internalServerError = 500
    case unknown = 0
}
