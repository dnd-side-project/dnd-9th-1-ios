//
//  Requestable.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/06.
//

import Foundation

protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> T?
}
