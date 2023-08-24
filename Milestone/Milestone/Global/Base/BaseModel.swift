//
//  BaseModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/21.
//

import Foundation

struct BaseModel<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T
}

// MARK: - data가 비었을 경우에 사용!

struct EmptyDataModel: Codable {
    let code: Int
    let message: String
    let data: [String: String]
}
