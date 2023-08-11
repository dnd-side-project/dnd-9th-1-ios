//
//  BaseModel.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

struct BaseModel<T: Decodable>: Decodable {
    var status: Int?
    var success: Bool?
    var message: String?
    var data: T?
    
    var statusCase: NetworkStatus? {
        return NetworkStatus(rawValue: status ?? 0)
    }
}
