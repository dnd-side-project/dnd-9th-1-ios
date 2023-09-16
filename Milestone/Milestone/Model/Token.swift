//
//  Token.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/22.
//

import Foundation

struct Token: Codable {
    let isFirstLogin: Bool
    let accessToken: String
    let refreshToken: String
}

struct RefreshToken: Codable {
    let accessToken: String
    let refreshToken: String
}
