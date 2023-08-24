//
//  Retrospect.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/23.
//

import Foundation

struct Retrospect: Codable {
    let hasGuide: Bool
    let contents: [String: String]
    let successLevel: String
}

struct RetrospectCount: Codable {
    let count: Int
}
