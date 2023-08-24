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
    
    enum CodingKeys: String, CodingKey {
        case hasGuide = "has_guide"
        case contents = "contents"
        case successLevel = "successLevel"
    }
    
    init(hasGuide: Bool, contents: [String: String], successLevel: String) {
        self.hasGuide = hasGuide
        self.contents = contents
        self.successLevel = successLevel
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hasGuide = (try? container.decode(Bool.self, forKey: .hasGuide)) ?? false
        self.contents = try container.decode([String : String].self, forKey: .contents)
        self.successLevel = try container.decode(String.self, forKey: .successLevel)
    }
}

struct RetrospectCount: Codable {
    let count: Int
}
