//
//  Post.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/18.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
