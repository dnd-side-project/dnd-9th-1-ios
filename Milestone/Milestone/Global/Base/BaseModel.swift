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
